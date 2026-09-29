class ChatbotTopicModel {
  const ChatbotTopicModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.order,
    required this.questionCount,
  });

  factory ChatbotTopicModel.fromJson(Map<String, dynamic> json) {
    return ChatbotTopicModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameAr: json['nameAr'] as String,
      descriptionEn: json['descriptionEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      order: json['order'] as int,
      questionCount: json['questionCount'] as int,
    );
  }

  final String id;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final int order;
  final int questionCount;
}
