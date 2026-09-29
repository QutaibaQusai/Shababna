import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/assistant_message.dart';
import '../cubit/chatbot_cubit.dart';

class ChatbotSuggestionChips extends StatelessWidget {
  const ChatbotSuggestionChips({super.key});

  static const _switchDuration = Duration(milliseconds: 250);
  static const _maxChipWidthFactor = 0.72;

  @override
  Widget build(BuildContext context) {
    final suggestions = context.select((ChatbotCubit cubit) => cubit.state.suggestions);

    return AnimatedSize(
      duration: _switchDuration,
      curve: Curves.easeOutCubic,
      alignment: AlignmentDirectional.bottomStart,
      child: AnimatedSwitcher(
        duration: _switchDuration,
        child: suggestions.isEmpty
            ? const SizedBox(key: ValueKey('empty'), width: double.infinity)
            : Padding(
                key: ValueKey(suggestions),
                padding: EdgeInsets.only(bottom: AppSpacing.xs),
                child: SizedBox(
                  height: AppSizes.iconButtonSize,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
                    itemCount: suggestions.length,
                    separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * _maxChipWidthFactor,
                      ),
                      child: _SuggestionChip(suggestion: suggestions[index]),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.suggestion});

  final AssistantSuggestion suggestion;

  (String, IconData?) _content(BuildContext context) {
    final isArabic = context.isArabic;
    return switch (suggestion) {
      TopicSuggestion(:final topic) => (topic.name(isArabic), null),
      QuestionSuggestion(:final question) => (question.question(isArabic), null),
      OtherTopicsSuggestion() => (context.l10n.assistantOtherTopics, LucideIcons.layoutGrid),
      RetrySuggestion() => (context.l10n.retry, LucideIcons.rotateCw),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (label, icon) = _content(context);
    final isAccent = suggestion is RetrySuggestion;
    final foreground = isAccent ? context.colorScheme.primary : context.colorScheme.onSurface;

    return Material(
      color: context.colorScheme.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: isAccent
              ? context.colorScheme.primary
              : context.colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.read<ChatbotCubit>().onSuggestionTap(suggestion),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconSm, color: foreground),
                SizedBox(width: AppSpacing.xxs + AppSpacing.xxs / 2),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
