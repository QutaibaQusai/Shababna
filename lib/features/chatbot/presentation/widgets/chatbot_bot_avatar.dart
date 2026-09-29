import 'package:flutter/material.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/theme/app_sizes.dart';

class ChatbotBotAvatar extends StatelessWidget {
  const ChatbotBotAvatar({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? AppSizes.chatAvatarSize;

    return ClipOval(
      child: Image.asset(
        AppAssets.logoIcon,
        width: dimension,
        height: dimension,
        fit: BoxFit.cover,
      ),
    );
  }
}
