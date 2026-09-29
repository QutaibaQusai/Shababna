class FaqSearchItemModel {
  const FaqSearchItemModel({
    required this.id,
    required this.chatbotId,
    required this.questionEn,
    required this.questionAr,
  });

  factory FaqSearchItemModel.fromJson(Map<String, dynamic> json) {
    return FaqSearchItemModel(
      id: json['id'] as String,
      chatbotId: json['chatbotId'] as String,
      questionEn: json['questionEn'] as String,
      questionAr: json['questionAr'] as String,
    );
  }

  final String id;
  final String chatbotId;
  final String questionEn;
  final String questionAr;
}
