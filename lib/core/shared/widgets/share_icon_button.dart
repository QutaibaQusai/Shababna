import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_config.dart';
import 'app_icon_button.dart';

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: LucideIcons.share,
      onPressed: () => SharePlus.instance.share(
        ShareParams(text: '${AppConfig.webBaseUrl}$path'),
      ),
    );
  }
}
