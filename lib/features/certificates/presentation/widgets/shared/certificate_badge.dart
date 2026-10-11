import 'package:flutter/material.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_svg_icon.dart';

class CertificateBadge extends StatelessWidget {
  const CertificateBadge({super.key, required this.size, this.isRevoked = false});

  final double size;
  final bool isRevoked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return AppSvgIcon(
      asset: AppAssets.iconCertificate,
      size: size,
      color: isRevoked ? colors.onSurfaceVariant : colors.primary,
    );
  }
}
