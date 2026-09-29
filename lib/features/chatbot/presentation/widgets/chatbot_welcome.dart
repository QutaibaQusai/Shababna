import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import 'chatbot_bot_avatar.dart';
import 'chatbot_topic_card.dart';

class ChatbotWelcome extends StatelessWidget {
  const ChatbotWelcome({super.key});

  static const _entranceDuration = Duration(milliseconds: 600);
  static const _entranceOffset = 24.0;

  @override
  Widget build(BuildContext context) {
    final composerHeight = context.watch<ComposerHeightNotifier>().height;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _entranceDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, _entranceOffset * (1 - value)), child: child),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          AppSpacing.lg,
          AppSpacing.screenMargin,
          composerHeight + AppSpacing.md,
        ),
        child: Column(
          children: [
            ChatbotBotAvatar(size: AppSizes.chatWelcomeLogoSize),
            SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.assistantWelcomeTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.assistantWelcomeSubtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            const _WelcomeTopics(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeTopics extends StatelessWidget {
  const _WelcomeTopics();

  static const _placeholderCount = 4;

  static const _placeholder = ChatbotTopic(
    id: 'placeholder',
    nameEn: 'Volunteering questions',
    nameAr: 'أسئلة التطوع',
    descriptionEn: null,
    descriptionAr: null,
    questionCount: 4,
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatbotCubit>().state;

    return switch (state.topicsStatus) {
      ChatbotTopicsStatus.failure => AppErrorWidget(
          message: context.l10n.somethingWentWrong,
          onRetry: context.read<ChatbotCubit>().start,
        ),
      ChatbotTopicsStatus.loading => Skeletonizer(
          enabled: true,
          child: _TopicsGrid(
            topics: List.filled(_placeholderCount, _placeholder),
            onTap: (_) {},
          ),
        ),
      ChatbotTopicsStatus.ready => _TopicsGrid(
          topics: state.topics,
          onTap: context.read<ChatbotCubit>().selectTopic,
        ),
    };
  }
}

class _TopicsGrid extends StatelessWidget {
  const _TopicsGrid({required this.topics, required this.onTap});

  static const _columns = 2;

  final List<ChatbotTopic> topics;
  final ValueChanged<ChatbotTopic> onTap;

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) return const SizedBox.shrink();
    final gap = AppSpacing.sm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.assistantTopicsLabel,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        for (var start = 0; start < topics.length; start += _columns) ...[
          if (start > 0) SizedBox(height: gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = start; index < start + _columns; index++) ...[
                  if (index > start) SizedBox(width: gap),
                  Expanded(
                    child: index < topics.length
                        ? ChatbotTopicCard(topic: topics[index], onTap: () => onTap(topics[index]))
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
