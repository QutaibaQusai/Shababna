import '../../../../core/config/app_config.dart';
import '../../domain/repositories/home_repository.dart';
import '../models/home_models.dart';

extension HomeSlideModelMapper on HomeSlideModel {
  HomeSlide toEntity() => HomeSlide(
    id: id,
    titleEn: _plainText(titleEn),
    titleAr: _plainText(titleAr),
    descriptionEn: _plainText(descriptionEn),
    descriptionAr: _plainText(descriptionAr),
    imageUrl: _absoluteUrl(imageUrl),
  );
}

extension HomeProfileModelMapper on HomeProfileModel {
  HomeImpact toEntity() => HomeImpact(
    fullNameEn: fullNameEn.trim(),
    fullNameAr: fullNameAr.trim(),
    hours: volunteeringHours,
    tier: tier?.toEntity(),
    nextTier: nextTier?.toEntity(),
    remainingHours: nextTier?.remainingHours ?? 0,
    progressPercentage: tierProgressPercentage.clamp(0, 100),
  );
}

extension on HomeTierModel {
  HomeTier toEntity() => HomeTier(
    name: name,
    color: _parseColor(color),
    lightIconUrl: _absoluteUrl(lightIconUrl),
    darkIconUrl: _absoluteUrl(darkIconUrl),
  );
}

extension HomeEventModelMapper on HomeEventModel {
  HomeEvent? toEntity() {
    final start = DateTime.tryParse(from);
    final end = DateTime.tryParse(to);
    if (id.isEmpty || start == null || end == null) return null;
    return HomeEvent(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      typeName: typeName,
      from: start,
      to: end,
      imageUrl: _absoluteUrl(imageUrl),
    );
  }
}

extension HomeNewsModelMapper on HomeNewsModel {
  HomeNews? toEntity() {
    final parsedDate = DateTime.tryParse(date);
    if (id.isEmpty || parsedDate == null) return null;
    return HomeNews(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      summaryEn: _plainText(descriptionEn),
      summaryAr: _plainText(descriptionAr),
      date: parsedDate,
      imageUrl: _absoluteUrl(imageUrl),
    );
  }
}

extension HomeTaskModelMapper on HomeTaskModel {
  HomeTask? toOpenTask() {
    final isOpen = submissionStatus == null || submissionStatus == _rejectedStatus;
    if (!isOpen || id.isEmpty) return null;
    final due = dueAtUtc;
    return HomeTask(
      id: id,
      nameEn: nameEn,
      nameAr: nameAr,
      eventTitleEn: eventTitleEn,
      eventTitleAr: eventTitleAr,
      dueAt: due == null ? null : DateTime.tryParse(due)?.toLocal(),
      needsChanges: submissionStatus == _rejectedStatus,
    );
  }
}

const _rejectedStatus = 'Rejected';
const _defaultTierColor = 0xFF004C96;
final _tags = RegExp(r'<[^>]*>');
final _whitespace = RegExp(r'\s+');
const _entities = {
  '&nbsp;': ' ',
  '&amp;': '&',
  '&quot;': '"',
  '&#39;': "'",
  '&apos;': "'",
  '&lt;': '<',
  '&gt;': '>',
};

String _absoluteUrl(String path) =>
    path.isEmpty || path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';

String _plainText(String html) {
  var text = html.replaceAll(_tags, ' ');
  _entities.forEach((entity, value) => text = text.replaceAll(entity, value));
  return text.replaceAll(_whitespace, ' ').trim();
}

int _parseColor(String hex) {
  final digits = hex.replaceFirst('#', '');
  final value = int.tryParse(digits, radix: 16);
  if (value == null) return _defaultTierColor;
  return switch (digits.length) {
    6 => 0xFF000000 | value,
    8 => value,
    _ => _defaultTierColor,
  };
}
