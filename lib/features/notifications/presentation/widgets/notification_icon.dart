import 'package:flutter/material.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/notifications/push_message.dart';
import '../../../../core/shared/widgets/app_svg_icon.dart';
import '../../../../core/theme/app_sizes.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, required this.type, required this.color});

  final NotificationType type;
  final Color color;

  String get _asset => switch (type) {
    NotificationType.news => AppAssets.iconNews,
    NotificationType.event => AppAssets.iconCalendar,
    NotificationType.registration => AppAssets.iconRegistration,
    NotificationType.task => AppAssets.iconTask,
    NotificationType.tier => AppAssets.iconTier,
    NotificationType.certificate => AppAssets.iconCertificate,
    NotificationType.general ||
    NotificationType.unknown => AppAssets.iconAssociationHeart,
  };

  @override
  Widget build(BuildContext context) {
    return AppSvgIcon(asset: _asset, size: AppSizes.iconMd, color: color);
  }
}
