import '../../../../core/shared/views/media_viewer/app_media.dart';
import '../../domain/repositories/events_repository.dart';

extension EventMediaMapper on EventDetails {
  List<AppMedia> get media => [
    if (imageUrl.isNotEmpty) AppImageMedia(imageUrl),
    ...images.map((image) => AppImageMedia(image.url)),
  ];
}
