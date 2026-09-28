import '../../../../core/config/app_config.dart';
import '../../domain/repositories/news_repository.dart';
import '../models/news_model.dart';

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
      imageUrl: _absoluteUrl(imageUrl),
      images: images
          .map((image) => NewsImage(id: image.id, url: _absoluteUrl(image.url)))
          .toList(),
      videos: videos
          .map(
            (video) => NewsVideo(
              id: video.id,
              url: video.isExternal ? video.url : _absoluteUrl(video.url),
              isExternal: video.isExternal,
            ),
          )
          .toList(),
    );
  }

  static final _tags = RegExp(r'<[^>]*>');
  static final _whitespace = RegExp(r'\s+');
  static const _entities = {
    '&nbsp;': ' ',
    '&amp;': '&',
    '&quot;': '"',
    '&#39;': "'",
    '&apos;': "'",
    '&lt;': '<',
    '&gt;': '>',
  };

  String _absoluteUrl(String path) =>
      path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';

  String _plainText(String html) {
    var text = html.replaceAll(_tags, ' ');
    _entities.forEach((entity, value) => text = text.replaceAll(entity, value));
    return text.replaceAll(_whitespace, ' ').trim();
  }
}
