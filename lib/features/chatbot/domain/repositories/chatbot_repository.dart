import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

class ChatbotTopic extends Equatable {
  const ChatbotTopic({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.questionCount,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int questionCount;

  String name(bool isArabic) => isArabic ? nameAr : nameEn;

  String? description(bool isArabic) => isArabic ? descriptionAr : descriptionEn;

  @override
  List<Object?> get props => [id, nameEn, nameAr, descriptionEn, descriptionAr, questionCount];
}

class FaqQuestionRef extends Equatable {
  const FaqQuestionRef({
    required this.id,
    required this.topicId,
    required this.questionEn,
    required this.questionAr,
  });

  final String id;
  final String topicId;
  final String questionEn;
  final String questionAr;

  String question(bool isArabic) => isArabic ? questionAr : questionEn;

  @override
  List<Object?> get props => [id, topicId, questionEn, questionAr];
}

class FaqQuestion extends Equatable {
  const FaqQuestion({
    required this.id,
    required this.topicId,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.imageUrl,
    required this.videoUrl,
    required this.isExternalVideo,
  });

  final String id;
  final String topicId;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final String? imageUrl;
  final String? videoUrl;
  final bool isExternalVideo;

  String question(bool isArabic) => isArabic ? questionAr : questionEn;

  String answer(bool isArabic) => isArabic ? answerAr : answerEn;

  FaqQuestionRef get ref =>
      FaqQuestionRef(id: id, topicId: topicId, questionEn: questionEn, questionAr: questionAr);

  @override
  List<Object?> get props => [
        id,
        topicId,
        questionEn,
        questionAr,
        answerEn,
        answerAr,
        imageUrl,
        videoUrl,
        isExternalVideo,
      ];
}

abstract interface class ChatbotRepository {
  Future<Either<Failure, List<ChatbotTopic>>> getTopics();

  Future<Either<Failure, List<FaqQuestion>>> getQuestions(String topicId);

  Future<Either<Failure, FaqQuestion>> getQuestion(FaqQuestionRef ref);

  Future<Either<Failure, List<FaqQuestionRef>>> searchQuestions(String query, {required int limit});
}
