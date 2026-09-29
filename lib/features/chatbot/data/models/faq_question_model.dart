class FaqQuestionModel {
  const FaqQuestionModel({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.order,
    required this.imageUrl,
    required this.videoUrl,
    required this.isExternalVideo,
  });

  factory FaqQuestionModel.fromJson(Map<String, dynamic> json) {
    return FaqQuestionModel(
      id: json['id'] as String,
      questionEn: json['questionEn'] as String,
      questionAr: json['questionAr'] as String,
      answerEn: json['answerEn'] as String,
      answerAr: json['answerAr'] as String,
      order: json['order'] as int,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      isExternalVideo: json['isExternalVideo'] as bool,
    );
  }

  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final int order;
  final String? imageUrl;
  final String? videoUrl;
  final bool isExternalVideo;
}
