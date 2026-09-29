import '../../../../core/network/api_consumer.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/paged_result.dart';
import '../models/chatbot_topic_model.dart';
import '../models/faq_question_model.dart';
import '../models/faq_search_item_model.dart';

class ChatbotRemoteDataSource {
  ChatbotRemoteDataSource(this._apiConsumer);

  static const _maxPageSize = 100;

  final ApiConsumer _apiConsumer;

  Future<List<ChatbotTopicModel>> getTopics() async {
    final response = await _apiConsumer.get(
      EndPoints.chatbots,
      queryParameters: {'Page': 1, 'PageSize': _maxPageSize},
    );
    return PagedResult.fromJson(
      response as Map<String, dynamic>,
      ChatbotTopicModel.fromJson,
    ).items;
  }

  Future<List<FaqQuestionModel>> getQuestions(String topicId) async {
    final response = await _apiConsumer.get(
      EndPoints.chatbotQuestions(topicId),
      queryParameters: {'Page': 1, 'PageSize': _maxPageSize},
    );
    return PagedResult.fromJson(
      response as Map<String, dynamic>,
      FaqQuestionModel.fromJson,
    ).items;
  }

  Future<FaqQuestionModel> getQuestion(String topicId, String questionId) async {
    final response = await _apiConsumer.get(EndPoints.chatbotQuestion(topicId, questionId));
    return FaqQuestionModel.fromJson(response as Map<String, dynamic>);
  }

  Future<List<FaqSearchItemModel>> searchQuestions(String query, {required int limit}) async {
    final response = await _apiConsumer.get(
      EndPoints.chatbotQuestionsSearch,
      queryParameters: {'Q': query, 'Page': 1, 'PageSize': limit},
    );
    return PagedResult.fromJson(
      response as Map<String, dynamic>,
      FaqSearchItemModel.fromJson,
    ).items;
  }
}
