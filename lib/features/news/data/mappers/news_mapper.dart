import '../../../../core/config/app_config.dart';
import '../../domain/repositories/news_repository.dart';
import '../models/news_model.dart';
import '../models/news_search_item_model.dart';

extension NewsSummaryModelMapper on NewsSummaryModel {
  NewsSummary toEntity() {
    return NewsSummary(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      summaryEn: _plainText(descriptionEn),
      summaryAr: _plainText(descriptionAr),
      date: DateTime.parse(date),
      imageUrl: _toAbsoluteUrl(imageUrl),
    );
  }
}

extension NewsModelMapper on NewsModel {
  NewsArticle toEntity() {
    return NewsArticle(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      summaryEn: _plainText(descriptionEn),
      summaryAr: _plainText(descriptionAr),
      date: DateTime.parse(date),
      imageUrl: _toAbsoluteUrl(imageUrl),
      images: images
          .where((image) => image.url.isNotEmpty)
          .map((image) => NewsImage(id: image.id, url: _toAbsoluteUrl(image.url)))
          .toList(),
      videos: videos
          .where((video) => video.url.isNotEmpty)
          .map(
            (video) => NewsVideo(
              id: video.id,
              url: video.isExternal ? video.url : _toAbsoluteUrl(video.url),
              isExternal: video.isExternal,
            ),
          )
          .toList(),
    );
  }
}

extension NewsSearchItemModelMapper on NewsSearchItemModel {
  NewsSearchResult toEntity() {
    return NewsSearchResult(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      date: DateTime.parse(date),
      imageUrl: _toAbsoluteUrl(imageUrl),
    );
  }
}

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

String _plainText(String html) {
  var text = html.replaceAll(_tags, ' ');
  _entities.forEach((entity, value) => text = text.replaceAll(entity, value));
  return text.replaceAll(_whitespace, ' ').trim();
}

String _toAbsoluteUrl(String path) =>
    path.isEmpty || path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';
