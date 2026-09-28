class NewsImageModel {
  const NewsImageModel({required this.id, required this.url});

  factory NewsImageModel.fromJson(Map<String, dynamic> json) {
    return NewsImageModel(id: json['id'] as String, url: json['url'] as String);
  }

  final String id;
  final String url;
}

class NewsVideoModel {
  const NewsVideoModel({required this.id, required this.url, required this.isExternal});

  factory NewsVideoModel.fromJson(Map<String, dynamic> json) {
    return NewsVideoModel(
      id: json['id'] as String,
      url: json['url'] as String,
      isExternal: json['isExternal'] as bool,
    );
  }

  final String id;
  final String url;
  final bool isExternal;
}

class NewsModel {
  const NewsModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.date,
    required this.imageUrl,
    required this.images,
    required this.videos,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String,
      titleAr: json['titleAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String,
      images: (json['images'] as List<dynamic>)
          .map((item) => NewsImageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((item) => NewsVideoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String date;
  final String imageUrl;
  final List<NewsImageModel> images;
  final List<NewsVideoModel> videos;
}
