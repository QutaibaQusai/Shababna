double parseHomeDouble(Object? value) => switch (value) {
  num() => value.toDouble(),
  String() => double.tryParse(value) ?? 0,
  _ => 0,
};

int parseHomeInt(Object? value) => switch (value) {
  int() => value,
  num() => value.toInt(),
  String() => int.tryParse(value) ?? 0,
  _ => 0,
};

List<Map<String, dynamic>> parseHomeItems(Object? response) {
  if (response is! Map<String, dynamic>) return const [];
  final items = response['items'];
  if (items is! List) return const [];
  return items.whereType<Map<String, dynamic>>().toList();
}

List<Map<String, dynamic>> parseHomeList(Object? response) {
  if (response is! List) return const [];
  return response.whereType<Map<String, dynamic>>().toList();
}

class HomeOccasionModel {
  const HomeOccasionModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
  });

  factory HomeOccasionModel.fromJson(Map<String, dynamic> json) {
    return HomeOccasionModel(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
}

class HomeSlideModel {
  const HomeSlideModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.order,
    required this.imageUrl,
  });

  factory HomeSlideModel.fromJson(Map<String, dynamic> json) {
    return HomeSlideModel(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      order: parseHomeInt(json['order']),
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final int order;
  final String imageUrl;
}

class HomeTierModel {
  const HomeTierModel({
    required this.name,
    required this.color,
    required this.lightIconUrl,
    required this.darkIconUrl,
    required this.remainingHours,
  });

  factory HomeTierModel.fromJson(Map<String, dynamic> json) {
    return HomeTierModel(
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
      lightIconUrl: json['lightIconUrl'] as String? ?? '',
      darkIconUrl: json['darkIconUrl'] as String? ?? '',
      remainingHours: parseHomeDouble(json['remainingHours']),
    );
  }

  final String name;
  final String color;
  final String lightIconUrl;
  final String darkIconUrl;
  final double remainingHours;
}

class HomeProfileModel {
  const HomeProfileModel({
    required this.fullNameEn,
    required this.fullNameAr,
    required this.volunteeringHours,
    required this.tier,
    required this.nextTier,
    required this.tierProgressPercentage,
  });

  factory HomeProfileModel.fromJson(Map<String, dynamic> json) {
    final tier = json['tier'];
    final nextTier = json['nextTier'];
    return HomeProfileModel(
      fullNameEn: json['fullNameEn'] as String? ?? '',
      fullNameAr: json['fullNameAr'] as String? ?? '',
      volunteeringHours: parseHomeDouble(json['volunteeringHours']),
      tier: tier is Map<String, dynamic> ? HomeTierModel.fromJson(tier) : null,
      nextTier: nextTier is Map<String, dynamic> ? HomeTierModel.fromJson(nextTier) : null,
      tierProgressPercentage: parseHomeInt(json['tierProgressPercentage']),
    );
  }

  final String fullNameEn;
  final String fullNameAr;
  final double volunteeringHours;
  final HomeTierModel? tier;
  final HomeTierModel? nextTier;
  final int tierProgressPercentage;
}

class HomeVolunteeringOpportunityModel {
  const HomeVolunteeringOpportunityModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.typeName,
    required this.from,
    required this.to,
    required this.imageUrl,
  });

  factory HomeVolunteeringOpportunityModel.fromJson(Map<String, dynamic> json) {
    final type = json['eventType'];
    return HomeVolunteeringOpportunityModel(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      typeName: type is Map<String, dynamic> ? type['name'] as String? ?? '' : '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String typeName;
  final String from;
  final String to;
  final String imageUrl;
}

class HomeNewsModel {
  const HomeNewsModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.date,
    required this.imageUrl,
  });

  factory HomeNewsModel.fromJson(Map<String, dynamic> json) {
    return HomeNewsModel(
      id: json['id'] as String? ?? '',
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionAr: json['descriptionAr'] as String? ?? '',
      date: json['date'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String date;
  final String imageUrl;
}

class HomeTaskModel {
  const HomeTaskModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.volunteeringOpportunityTitleEn,
    required this.volunteeringOpportunityTitleAr,
    required this.dueAtUtc,
    required this.submissionStatus,
  });

  factory HomeTaskModel.fromJson(Map<String, dynamic> json) {
    return HomeTaskModel(
      id: json['id'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      volunteeringOpportunityTitleEn: json['eventTitleEn'] as String? ?? '',
      volunteeringOpportunityTitleAr: json['eventTitleAr'] as String? ?? '',
      dueAtUtc: json['dueAtUtc'] as String?,
      submissionStatus: json['mySubmissionStatus'] as String?,
    );
  }

  final String id;
  final String nameEn;
  final String nameAr;
  final String volunteeringOpportunityTitleEn;
  final String volunteeringOpportunityTitleAr;
  final String? dueAtUtc;
  final String? submissionStatus;
}
