import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_remote_data_source.dart';
import '../mappers/chatbot_mapper.dart';

class ChatbotRepositoryImpl with RepositoryGuardMixin implements ChatbotRepository {
  ChatbotRepositoryImpl(this._remoteDataSource);

  final ChatbotRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<ChatbotTopic>>> getTopics() {
    return guard(() async {
      final topics = await _remoteDataSource.getTopics();
      return topics.map((topic) => topic.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, List<FaqQuestion>>> getQuestions(String topicId) {
    return guard(() async {
      final questions = await _remoteDataSource.getQuestions(topicId);
      return questions.map((question) => question.toEntity(topicId)).toList();
    });
  }

  @override
  Future<Either<Failure, FaqQuestion>> getQuestion(FaqQuestionRef ref) {
    return guard(() async {
      final question = await _remoteDataSource.getQuestion(ref.topicId, ref.id);
      return question.toEntity(ref.topicId);
    });
  }

  @override
  Future<Either<Failure, List<FaqQuestionRef>>> searchQuestions(
    String query, {
    required int limit,
  }) {
    return guard(() async {
      final items = await _remoteDataSource.searchQuestions(query, limit: limit);
      return items.map((item) => item.toEntity()).toList();
    });
  }
}
