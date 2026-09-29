import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/chatbot_cubit.dart';
import 'chatbot_bot_avatar.dart';

class ChatbotTypingBubble extends StatelessWidget {
  const ChatbotTypingBubble({super.key});

  static const _switchDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final isTyping = context.select((ChatbotCubit cubit) => cubit.state.isBotTyping);

    return AnimatedSwitcher(
      duration: _switchDuration,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(sizeFactor: animation, alignment: AlignmentDirectional.topStart, child: child),
      ),
      child: isTyping
          ? Padding(
              key: const ValueKey('typing'),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                AppSpacing.xs,
                AppSpacing.screenMargin,
                AppSpacing.xs,
              ),
              child: Semantics(
                label: context.l10n.assistantTyping,
                child: Row(
                  children: [
                    const ChatbotBotAvatar(),
                    SizedBox(width: AppSpacing.xs),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surfaceContainerHighest,
                        borderRadius: AppRadius.pillRadius,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.sm - AppSpacing.xxs,
                        ),
                        child: IsTypingIndicator(color: context.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(key: ValueKey('idle'), width: double.infinity),
    );
  }
}
