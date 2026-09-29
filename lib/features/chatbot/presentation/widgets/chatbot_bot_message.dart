import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/assistant_message.dart';
import '../cubit/chatbot_cubit.dart';
import '../utils/html_plain_text.dart';
import 'chatbot_answer_media.dart';
import 'chatbot_bot_avatar.dart';
import 'chatbot_typewriter.dart';

class ChatbotBotMessage extends StatelessWidget {
  const ChatbotBotMessage({
    super.key,
    required this.message,
    required this.animate,
    required this.onRevealed,
  });

  static const _maxWidthFactor = 0.86;

  final AssistantMessage message;
  final bool animate;
  final VoidCallback onRevealed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * _maxWidthFactor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ChatbotBotAvatar(),
          SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.assistantBotName,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                switch (message) {
                  final BotAnswerMessage answer => _AnswerContent(
                      message: answer,
                      animate: animate,
                      onRevealed: onRevealed,
                    ),
                  final BotTextMessage text => _TextContent(
                      message: text,
                      animate: animate,
                      onRevealed: onRevealed,
                    ),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({required this.message, required this.animate, required this.onRevealed});

  final BotTextMessage message;
  final bool animate;
  final VoidCallback onRevealed;

  String _text(BuildContext context) {
    final l10n = context.l10n;
    final topicName = message.topic?.name(context.isArabic) ?? '';
    return switch (message.kind) {
      BotTextKind.topicIntro => l10n.assistantTopicIntro(topicName),
      BotTextKind.pickTopic => l10n.assistantPickTopic,
      BotTextKind.didYouMean => l10n.assistantDidYouMean,
      BotTextKind.noAnswer => l10n.assistantNoAnswer,
      BotTextKind.error => l10n.assistantError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final text = _text(context);
    final style = context.textTheme.bodyLarge?.copyWith(
      color: message.kind == BotTextKind.error
          ? context.colorScheme.error
          : context.colorScheme.onSurface,
      height: 1.5,
    );

    return ChatbotTypewriter(
      text: text,
      animate: animate,
      style: style,
      onCompleted: onRevealed,
      completedBuilder: (_) => Text(text, style: style),
    );
  }
}

class _AnswerContent extends StatelessWidget {
  const _AnswerContent({required this.message, required this.animate, required this.onRevealed});

  static const _lineHeight = 1.5;

  final BotAnswerMessage message;
  final bool animate;
  final VoidCallback onRevealed;

  Future<void> _openLink(String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.selectionClick();
    AppToast.success(context, context.l10n.assistantCopied);
  }

  @override
  Widget build(BuildContext context) {
    final question = message.question;
    final isArabic = context.isArabic;
    final html = question.answer(isArabic);
    final plainText = HtmlPlainText.from(html);
    final textStyle = context.textTheme.bodyLarge?.copyWith(
      color: context.colorScheme.onSurface,
      height: _lineHeight,
    );
    final topic = context.select(
      (ChatbotCubit cubit) => cubit.state.topicById(question.topicId),
    );

    return GestureDetector(
      onLongPress: () => _copy(context, plainText),
      child: ChatbotTypewriter(
        text: plainText,
        animate: animate,
        style: textStyle,
        onCompleted: onRevealed,
        completedBuilder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: html,
              onLinkTap: (url, attributes, element) => _openLink(url),
              style: {
                'body': Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(textStyle?.fontSize ?? 16),
                  lineHeight: const LineHeight(_lineHeight),
                  color: context.colorScheme.onSurface,
                ),
                'p': Style(margin: Margins.only(bottom: AppSpacing.xs)),
                'a': Style(color: context.colorScheme.primary),
              },
            ),
            ChatbotAnswerMedia(question: question),
            if (topic != null) ...[
              SizedBox(height: AppSpacing.xs),
              Text(
                context.l10n.assistantSource(topic.name(isArabic)),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
