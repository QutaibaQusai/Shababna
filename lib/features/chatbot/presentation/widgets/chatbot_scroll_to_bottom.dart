import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class ChatbotScrollToBottom extends StatelessWidget {
  const ChatbotScrollToBottom({super.key, required this.animation, required this.onPressed});

  final Animation<double> animation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final composerHeight = context.watch<ComposerHeightNotifier>().height;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final colors = context.colorScheme;
    final size = AppSizes.iconButtonSize;

    return PositionedDirectional(
      end: AppSpacing.screenMargin,
      bottom: composerHeight + bottomInset + AppSpacing.sm,
      child: ScaleTransition(
        scale: animation,
        child: Material(
          color: colors.surfaceContainerHighest,
          shape: CircleBorder(side: BorderSide(color: colors.outlineVariant)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Icon(LucideIcons.arrowDown, size: AppSizes.iconField, color: colors.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
