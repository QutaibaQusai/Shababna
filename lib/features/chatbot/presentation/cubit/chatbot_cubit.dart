import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../../domain/services/faq_answer_finder.dart';
import 'assistant_message.dart';
import 'chatbot_state.dart';

class _BotReply {
  const _BotReply(this.messages, this.suggestions);

  final List<AssistantMessage> messages;
  final List<AssistantSuggestion> suggestions;
}

typedef _ReplyProducer = Future<Either<Failure, _BotReply>> Function();

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit(this._repository, this._answerFinder) : super(const ChatbotState());

  static const _minTypingDuration = Duration(milliseconds: 750);

  final ChatbotRepository _repository;
  final FaqAnswerFinder _answerFinder;
  final _uuid = const Uuid();
  final _questionsByTopic = <String, List<FaqQuestion>>{};
  final _answeredIds = <String>{};
  _ReplyProducer? _retryProducer;
  int _conversation = 0;

  Future<void> start() async {
    emit(state.copyWith(topicsStatus: ChatbotTopicsStatus.loading));
    final result = await _repository.getTopics();
    if (isClosed) return;
    result.fold(
      (_) => emit(state.copyWith(topicsStatus: ChatbotTopicsStatus.failure)),
      (topics) => emit(state.copyWith(topicsStatus: ChatbotTopicsStatus.ready, topics: topics)),
    );
  }

  void onSuggestionTap(AssistantSuggestion suggestion) {
    switch (suggestion) {
      case TopicSuggestion(:final topic):
        selectTopic(topic);
      case QuestionSuggestion(:final question):
        askQuestion(question);
      case OtherTopicsSuggestion():
        showOtherTopics();
      case RetrySuggestion():
        retry();
    }
  }

  Future<void> selectTopic(ChatbotTopic topic) async {
    if (state.isBotTyping) return;
    _addUserMessage(UserTopicMessage(_newId(), topic));
    await _reply(() async {
      final result = await _loadQuestions(topic.id);
      return result.map(
        (questions) => _BotReply(
          [BotTextMessage(_newId(), BotTextKind.topicIntro, topic: topic)],
          [...questions.map((question) => QuestionSuggestion(question.ref)), const OtherTopicsSuggestion()],
        ),
      );
    });
  }

  Future<void> openQuestion({required String topicId, required String questionId}) async {
    final result = await _loadQuestions(topicId);
    if (isClosed) return;
    final question = result.fold(
      (_) => null,
      (questions) => questions.where((question) => question.id == questionId).firstOrNull,
    );
    if (question != null) await askQuestion(question.ref);
  }

  Future<void> askQuestion(FaqQuestionRef question) async {
    if (state.isBotTyping) return;
    _addUserMessage(UserQuestionMessage(_newId(), question));
    await _reply(() async {
      final result = await _findQuestion(question);
      return result.fold(
        (failure) async => Left<Failure, _BotReply>(failure),
        (answer) async => Right<Failure, _BotReply>(await _answerReply(answer)),
      );
    });
  }

  Future<void> sendText(String text) async {
    final message = text.trim();
    if (message.isEmpty || state.isBotTyping) return;
    _addUserMessage(UserTypedMessage(_newId(), message));
    await _reply(() async {
      final result = await _answerFinder.find(message);
      return result.fold((failure) async => Left<Failure, _BotReply>(failure), (match) async {
        return Right<Failure, _BotReply>(switch (match) {
          FaqSingleMatch(:final question) => await _answerReply(question),
          FaqSeveralMatches(:final candidates) => _BotReply(
              [BotTextMessage(_newId(), BotTextKind.didYouMean)],
              [...candidates.map(QuestionSuggestion.new), const OtherTopicsSuggestion()],
            ),
          FaqNoMatch() => _BotReply(
              [BotTextMessage(_newId(), BotTextKind.noAnswer)],
              _topicSuggestions(),
            ),
        });
      });
    });
  }

  Future<void> showOtherTopics() async {
    if (state.isBotTyping) return;
    _addUserMessage(UserOtherTopicsMessage(_newId()));
    await _reply(
      () async => Right(
        _BotReply([BotTextMessage(_newId(), BotTextKind.pickTopic)], _topicSuggestions()),
      ),
    );
  }

  Future<void> retry() async {
    final producer = _retryProducer;
    if (producer == null || state.isBotTyping) return;
    _retryProducer = null;
    await _reply(producer);
  }

  void restart() {
    _conversation++;
    _answeredIds.clear();
    _retryProducer = null;
    emit(state.copyWith(messages: const [], suggestions: const [], isBotTyping: false));
  }

  Future<void> _reply(_ReplyProducer produce) async {
    final conversation = _conversation;
    emit(state.copyWith(isBotTyping: true, suggestions: const []));

    final results = await Future.wait([produce(), Future<void>.delayed(_minTypingDuration)]);
    if (isClosed || conversation != _conversation) return;

    final result = results.first as Either<Failure, _BotReply>;
    result.fold(
      (_) {
        _retryProducer = produce;
        emit(state.copyWith(
          isBotTyping: false,
          messages: [...state.messages, BotTextMessage(_newId(), BotTextKind.error)],
          suggestions: const [RetrySuggestion()],
        ));
      },
      (reply) => emit(state.copyWith(
        isBotTyping: false,
        messages: [...state.messages, ...reply.messages],
        suggestions: reply.suggestions,
      )),
    );
  }

  Future<_BotReply> _answerReply(FaqQuestion answer) async {
    _answeredIds.add(answer.id);
    final followUps = await _loadQuestions(answer.topicId);
    final remaining = followUps
        .getOrElse(() => const [])
        .where((question) => !_answeredIds.contains(question.id))
        .map((question) => QuestionSuggestion(question.ref));
    return _BotReply(
      [BotAnswerMessage(_newId(), answer)],
      [...remaining, const OtherTopicsSuggestion()],
    );
  }

  Future<Either<Failure, FaqQuestion>> _findQuestion(FaqQuestionRef ref) async {
    final cached = _questionsByTopic[ref.topicId];
    if (cached != null) {
      for (final question in cached) {
        if (question.id == ref.id) return Right(question);
      }
    }
    return _repository.getQuestion(ref);
  }

  Future<Either<Failure, List<FaqQuestion>>> _loadQuestions(String topicId) async {
    final cached = _questionsByTopic[topicId];
    if (cached != null) return Right(cached);
    final result = await _repository.getQuestions(topicId);
    return result.map((questions) => _questionsByTopic[topicId] = questions);
  }

  List<AssistantSuggestion> _topicSuggestions() =>
      state.topics.map(TopicSuggestion.new).toList();

  void _addUserMessage(AssistantMessage message) {
    emit(state.copyWith(messages: [...state.messages, message], suggestions: const []));
  }

  String _newId() => _uuid.v4();
}
