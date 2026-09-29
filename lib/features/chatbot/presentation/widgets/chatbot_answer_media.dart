import 'package:flutter/material.dart';

import '../../../../core/shared/views/media_viewer/app_media.dart';
import '../../../../core/shared/views/media_viewer/media_video_tile.dart';
import '../../../../core/shared/views/media_viewer/show_media_browser.dart';
import '../../../../core/shared/widgets/app_network_image.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/chatbot_repository.dart';

class ChatbotAnswerMedia extends StatelessWidget {
  const ChatbotAnswerMedia({super.key, required this.question});

  final FaqQuestion question;

  List<AppMedia> get _media {
    final imageUrl = question.imageUrl;
    final videoUrl = question.videoUrl;
    return [
      if (imageUrl != null) AppImageMedia(imageUrl),
      if (videoUrl != null) AppVideoMedia(videoUrl, isExternal: question.isExternalVideo),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final media = _media;
    if (media.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in media) ...[
          SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: SizedBox(
              height: AppSizes.chatMediaHeight,
              child: GestureDetector(
                onTap: () => showMediaBrowser(context, media: media),
                child: switch (item) {
                  AppImageMedia(:final url) => AppNetworkImage(url: url, size: AppSizes.iconLg * 2),
                  AppVideoMedia() => const MediaVideoTile(),
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
