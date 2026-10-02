class SearchEventItemModel {
  const SearchEventItemModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.eventTypeNameEn,
    required this.eventTypeNameAr,
    required this.from,
    required this.to,
    required this.status,
    required this.imageUrl,
  });

  factory SearchEventItemModel.fromJson(Map<String, dynamic> json) {
    return SearchEventItemModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      eventTypeNameEn: json['eventTypeNameEn'] as String? ?? '',
      eventTypeNameAr: json['eventTypeNameAr'] as String? ?? '',
      from: json['from'] as String,
      to: json['to'] as String,
      status: json['status'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String eventTypeNameEn;
  final String eventTypeNameAr;
  final String from;
  final String to;
  final String status;
  final String imageUrl;
}

class SearchNewsItemModel {
  const SearchNewsItemModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.date,
    required this.imageUrl,
  });

  factory SearchNewsItemModel.fromJson(Map<String, dynamic> json) {
    return SearchNewsItemModel(
      id: json['id'] as String,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      date: json['date'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String date;
  final String imageUrl;
}

class SearchFaqItemModel {
  const SearchFaqItemModel({
    required this.id,
    required this.chatbotId,
    required this.chatbotNameEn,
    required this.chatbotNameAr,
    required this.questionEn,
    required this.questionAr,
  });

  factory SearchFaqItemModel.fromJson(Map<String, dynamic> json) {
    return SearchFaqItemModel(
      id: json['id'] as String,
      chatbotId: json['chatbotId'] as String,
      chatbotNameEn: json['chatbotNameEn'] as String? ?? '',
      chatbotNameAr: json['chatbotNameAr'] as String? ?? '',
      questionEn: json['questionEn'] as String? ?? '',
      questionAr: json['questionAr'] as String? ?? '',
    );
  }

  final String id;
  final String chatbotId;
  final String chatbotNameEn;
  final String chatbotNameAr;
  final String questionEn;
  final String questionAr;
}

class SearchGroupModel<T> {
  const SearchGroupModel({required this.items, required this.hasMore});

  factory SearchGroupModel.fromJson(
    Object? json,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (json is! Map<String, dynamic>) return SearchGroupModel(items: [], hasMore: false);
    final items = json['items'];
    return SearchGroupModel(
      items: items is List
          ? items.whereType<Map<String, dynamic>>().map(fromJson).toList()
          : <T>[],
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  final List<T> items;
  final bool hasMore;
}

class GlobalSearchResponseModel {
  const GlobalSearchResponseModel({
    required this.events,
    required this.news,
    required this.faq,
  });

  factory GlobalSearchResponseModel.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResponseModel(
      events: SearchGroupModel.fromJson(json['events'], SearchEventItemModel.fromJson),
      news: SearchGroupModel.fromJson(json['news'], SearchNewsItemModel.fromJson),
      faq: SearchGroupModel.fromJson(json['faq'], SearchFaqItemModel.fromJson),
    );
  }

  final SearchGroupModel<SearchEventItemModel> events;
  final SearchGroupModel<SearchNewsItemModel> news;
  final SearchGroupModel<SearchFaqItemModel> faq;
}
