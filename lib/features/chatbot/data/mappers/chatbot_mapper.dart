import '../../../../core/config/app_config.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../models/chatbot_topic_model.dart';
import '../models/faq_question_model.dart';
import '../models/faq_search_item_model.dart';

extension ChatbotTopicModelMapper on ChatbotTopicModel {
  ChatbotTopic toEntity() {
    return ChatbotTopic(
      id: id,
      nameEn: nameEn,
      nameAr: nameAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      questionCount: questionCount,
    );
  }
}

extension FaqQuestionModelMapper on FaqQuestionModel {
  FaqQuestion toEntity(String topicId) {
    final videoUrl = this.videoUrl;
    return FaqQuestion(
      id: id,
      topicId: topicId,
      questionEn: questionEn,
      questionAr: questionAr,
      answerEn: answerEn,
      answerAr: answerAr,
      imageUrl: imageUrl == null ? null : _absoluteUrl(imageUrl!),
      videoUrl: videoUrl == null || isExternalVideo ? videoUrl : _absoluteUrl(videoUrl),
      isExternalVideo: isExternalVideo,
    );
  }
}

extension FaqSearchItemModelMapper on FaqSearchItemModel {
  FaqQuestionRef toEntity() {
    return FaqQuestionRef(
      id: id,
      topicId: chatbotId,
      questionEn: questionEn,
      questionAr: questionAr,
    );
  }
}

String _absoluteUrl(String path) =>
    path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';
