import 'package:flutter/widgets.dart';

import 'app_media.dart';
import 'media_gallery_page.dart';
import 'media_viewer_page.dart';

Future<void> showMediaBrowser(BuildContext context, {required List<AppMedia> media}) {
  if (media.length > 1) {
    return MediaGalleryPage.show(context, media: media);
  }
  return MediaViewerPage.show(context, media: media, initialIndex: 0);
}
