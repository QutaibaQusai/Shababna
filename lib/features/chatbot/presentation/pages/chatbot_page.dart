import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_icon_button.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/assistant_message.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';
import '../widgets/chatbot_bot_message.dart';
import '../widgets/chatbot_composer.dart';
import '../widgets/chatbot_scroll_to_bottom.dart';
import '../widgets/chatbot_typing_bubble.dart';
import '../widgets/chatbot_user_bubble.dart';
import '../widgets/chatbot_welcome.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key, this.topicId, this.questionId});

  final String? topicId;
  final String? questionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<ChatbotCubit>()..start();
        final topicId = this.topicId;
        final questionId = this.questionId;
        if (topicId != null && questionId != null) {
          cubit.openQuestion(topicId: topicId, questionId: questionId);
        }
        return cubit;
      },
      child: const _ChatbotView(),
    );
  }
}

class _ChatbotView extends StatefulWidget {
  const _ChatbotView();

  @override
  State<_ChatbotView> createState() => _ChatbotViewState();
}

class _ChatbotViewState extends State<_ChatbotView> {
  static const _userId = 'user';
  static const _botId = 'assistant';
  static const _entryKey = 'entry';
  static const _insertDuration = Duration(milliseconds: 320);
  static const _scrollDuration = Duration(milliseconds: 300);

  final _chatController = InMemoryChatController();
  final _scrollController = ScrollController();
  final _revealedIds = <String>{};

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _syncMessages(List<AssistantMessage> messages) async {
    final current = _chatController.messages;
    if (messages.length < current.length) {
      _revealedIds.clear();
      await _chatController.setMessages(messages.map(_toChatMessage).toList());
      return;
    }
    final knownIds = current.map((message) => message.id).toSet();
    final added = messages.where((message) => !knownIds.contains(message.id)).toList();
    if (added.isEmpty) return;
    await _chatController.insertAllMessages(added.map(_toChatMessage).toList());
  }

  Message _toChatMessage(AssistantMessage message) {
    return Message.custom(
      id: message.id,
      authorId: message.isFromUser ? _userId : _botId,
      createdAt: DateTime.now(),
      metadata: {_entryKey: message},
    );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _scrollDuration,
        curve: Curves.easeOutCubic,
      );
    });
  }

  ChatTheme _chatTheme(BuildContext context) {
    final colors = context.colorScheme;
    final text = context.textTheme;
    const fallback = TextStyle();

    return ChatTheme(
      colors: ChatColors(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: Theme.of(context).scaffoldBackgroundColor,
        onSurface: colors.onSurface,
        surfaceContainer: colors.surfaceContainer,
        surfaceContainerLow: colors.surfaceContainerLow,
        surfaceContainerHigh: colors.surfaceContainerHighest,
      ),
      typography: ChatTypography(
        bodyLarge: text.bodyLarge ?? fallback,
        bodyMedium: text.bodyMedium ?? fallback,
        bodySmall: text.bodySmall ?? fallback,
        labelLarge: text.labelLarge ?? fallback,
        labelMedium: text.labelMedium ?? fallback,
        labelSmall: text.labelSmall ?? fallback,
      ),
      shape: BorderRadius.all(Radius.circular(AppRadius.xl)),
    );
  }

  String _userText(BuildContext context, AssistantMessage message) {
    final isArabic = context.isArabic;
    return switch (message) {
      UserTypedMessage(:final text) => text,
      UserTopicMessage(:final topic) => topic.name(isArabic),
      UserQuestionMessage(:final question) => question.question(isArabic),
      UserOtherTopicsMessage() => context.l10n.assistantOtherTopics,
      _ => '',
    };
  }

  Widget _buildMessage(BuildContext context, CustomMessage message) {
    final entry = message.metadata?[_entryKey];
    if (entry is! AssistantMessage) return const SizedBox.shrink();
    if (entry.isFromUser) return ChatbotUserBubble(text: _userText(context, entry));

    return ChatbotBotMessage(
      message: entry,
      animate: !_revealedIds.contains(entry.id),
      onRevealed: () => _revealedIds.add(entry.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatbotCubit>();
    final hasConversation = context.select((ChatbotCubit cubit) => cubit.state.hasConversation);
    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ChatbotCubit, ChatbotState>(
          listenWhen: (previous, current) => previous.messages != current.messages,
          listener: (context, state) => _syncMessages(state.messages),
        ),
        BlocListener<ChatbotCubit, ChatbotState>(
          listenWhen: (previous, current) => !previous.isBotTyping && current.isBotTyping,
          listener: (context, state) => _scrollToEnd(),
        ),
      ],
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.assistantTitle,
          onBack: () => context.pop(),
          actions: hasConversation
              ? [
                  AppIconButton(
                    icon: LucideIcons.squarePen,
                    semanticLabel: context.l10n.assistantNewChat,
                    onPressed: cubit.restart,
                  ),
                ]
              : null,
        ),
        body: Chat(
          currentUserId: _userId,
          resolveUser: (id) async => User(id: id),
          chatController: _chatController,
          theme: _chatTheme(context),
          backgroundColor: theme.scaffoldBackgroundColor,
          builders: Builders(
            customMessageBuilder: (context, message, index, {required isSentByMe, groupStatus}) =>
                _buildMessage(context, message),
            chatMessageBuilder: (
              context,
              message,
              index,
              animation,
              child, {
              isRemoved,
              required isSentByMe,
              groupStatus,
            }) =>
                ChatMessage(
                  message: message,
                  index: index,
                  animation: animation,
                  isRemoved: isRemoved,
                  groupStatus: groupStatus,
                  horizontalPadding: AppSpacing.screenMargin,
                  verticalPadding: AppSpacing.xs,
                  child: child,
                ),
            chatAnimatedListBuilder: (context, itemBuilder) => ChatAnimatedList(
              itemBuilder: itemBuilder,
              scrollController: _scrollController,
              insertAnimationDuration: _insertDuration,
              bottomSliver: const SliverToBoxAdapter(child: ChatbotTypingBubble()),
            ),
            scrollToBottomBuilder: (context, animation, onPressed) =>
                ChatbotScrollToBottom(animation: animation, onPressed: onPressed),
            composerBuilder: (_) => const ChatbotComposer(),
            emptyChatListBuilder: (_) => const ChatbotWelcome(),
          ),
        ),
      ),
    );
  }
}
