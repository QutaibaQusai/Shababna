class NewsSearchItemModel {
  const NewsSearchItemModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.date,
    required this.imageUrl,
  });

  factory NewsSearchItemModel.fromJson(Map<String, dynamic> json) {
    return NewsSearchItemModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String date;
  final String imageUrl;
}
