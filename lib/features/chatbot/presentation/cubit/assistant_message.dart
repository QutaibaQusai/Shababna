import 'package:equatable/equatable.dart';

import '../../domain/repositories/chatbot_repository.dart';

sealed class AssistantMessage extends Equatable {
  const AssistantMessage(this.id);

  final String id;

  bool get isFromUser;

  @override
  List<Object?> get props => [id];
}

class UserTypedMessage extends AssistantMessage {
  const UserTypedMessage(super.id, this.text);

  final String text;

  @override
  bool get isFromUser => true;
}

class UserTopicMessage extends AssistantMessage {
  const UserTopicMessage(super.id, this.topic);

  final ChatbotTopic topic;

  @override
  bool get isFromUser => true;
}

class UserQuestionMessage extends AssistantMessage {
  const UserQuestionMessage(super.id, this.question);

  final FaqQuestionRef question;

  @override
  bool get isFromUser => true;
}

class UserOtherTopicsMessage extends AssistantMessage {
  const UserOtherTopicsMessage(super.id);

  @override
  bool get isFromUser => true;
}

enum BotTextKind { topicIntro, pickTopic, didYouMean, noAnswer, error }

class BotTextMessage extends AssistantMessage {
  const BotTextMessage(super.id, this.kind, {this.topic});

  final BotTextKind kind;
  final ChatbotTopic? topic;

  @override
  bool get isFromUser => false;
}

class BotAnswerMessage extends AssistantMessage {
  const BotAnswerMessage(super.id, this.question);

  final FaqQuestion question;

  @override
  bool get isFromUser => false;
}

sealed class AssistantSuggestion extends Equatable {
  const AssistantSuggestion();
}

class TopicSuggestion extends AssistantSuggestion {
  const TopicSuggestion(this.topic);

  final ChatbotTopic topic;

  @override
  List<Object?> get props => [topic];
}

class QuestionSuggestion extends AssistantSuggestion {
  const QuestionSuggestion(this.question);

  final FaqQuestionRef question;

  @override
  List<Object?> get props => [question];
}

class OtherTopicsSuggestion extends AssistantSuggestion {
  const OtherTopicsSuggestion();

  @override
  List<Object?> get props => [];
}

class RetrySuggestion extends AssistantSuggestion {
  const RetrySuggestion();

  @override
  List<Object?> get props => [];
}
