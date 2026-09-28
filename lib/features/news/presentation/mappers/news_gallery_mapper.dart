import '../../../../core/shared/views/media_viewer/app_media.dart';
import '../../domain/repositories/news_repository.dart';

extension NewsGalleryMapper on NewsArticle {
  List<AppMedia> get media => [
        AppImageMedia(imageUrl),
        ...images.map((image) => AppImageMedia(image.url)),
        ...videos.map((video) => AppVideoMedia(video.url, isExternal: video.isExternal)),
      ];
}
