import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../domain/verification_channel.dart';

class RegisterChannelSelector extends StatelessWidget {
  const RegisterChannelSelector({super.key, required this.value, required this.onChanged});

  final VerificationChannel value;
  final ValueChanged<VerificationChannel> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<VerificationChannel>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
          selectedBackgroundColor: colors.primary,
          selectedForegroundColor: colors.onPrimary,
        ),
        segments: [
          ButtonSegment(
            value: VerificationChannel.phone,
            label: Text(l10n.channelSms),
            icon: Icon(LucideIcons.messageSquare, size: AppSizes.iconField),
          ),
          ButtonSegment(
            value: VerificationChannel.email,
            label: Text(l10n.channelEmail),
            icon: Icon(LucideIcons.mail, size: AppSizes.iconField),
          ),
        ],
        selected: {value},
        onSelectionChanged: (selection) => onChanged(selection.first),
      ),
    );
  }
}
