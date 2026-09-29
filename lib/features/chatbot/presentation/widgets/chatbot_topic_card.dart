import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/chatbot_repository.dart';

class ChatbotTopicCard extends StatelessWidget {
  const ChatbotTopicCard({super.key, required this.topic, required this.onTap});

  static const _iconBackgroundOpacity = 0.12;

  final ChatbotTopic topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final iconSize = AppSizes.chatTopicIconSize;

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgRadius,
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: _iconBackgroundOpacity),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.messageCircleQuestion,
                  size: AppSizes.iconField,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                topic.name(context.isArabic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.xxs),
              Text(
                context.l10n.assistantTopicQuestions(topic.questionCount),
                style: context.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
