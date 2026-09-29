import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/chatbot_cubit.dart';
import 'chatbot_suggestion_chips.dart';

class ChatbotComposer extends StatefulWidget {
  const ChatbotComposer({super.key});

  @override
  State<ChatbotComposer> createState() => _ChatbotComposerState();
}

class _ChatbotComposerState extends State<ChatbotComposer> {
  static const _maxLines = 4;
  static const _blurSigma = 20.0;
  static const _backgroundOpacity = 0.88;

  final _measureKey = GlobalKey();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;
    final box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    context.read<ComposerHeightNotifier>().setHeight(box.size.height - bottomInset);
  }

  void _send() {
    final text = _textController.text.trim();
    final cubit = context.read<ChatbotCubit>();
    if (text.isEmpty || cubit.state.isBotTyping) return;
    cubit.sendText(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final background = Theme.of(context).scaffoldBackgroundColor;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
          child: NotificationListener<SizeChangedLayoutNotification>(
            onNotification: (_) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
              return true;
            },
            child: SizeChangedLayoutNotifier(
              child: ColoredBox(
                key: _measureKey,
                color: background.withValues(alpha: _backgroundOpacity),
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs, bottom: bottomInset),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ChatbotSuggestionChips(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.screenMargin,
                          0,
                          AppSpacing.screenMargin,
                          AppSpacing.sm,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: _buildInput(context)),
                            SizedBox(width: AppSpacing.xs),
                            ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _textController,
                              builder: (context, value, _) => _SendButton(
                                enabled: value.text.trim().isNotEmpty,
                                onPressed: _send,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: AppRadius.pillRadius,
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      minLines: 1,
      maxLines: _maxLines,
      textInputAction: TextInputAction.send,
      textCapitalization: TextCapitalization.sentences,
      keyboardAppearance: Theme.of(context).brightness,
      onSubmitted: (_) => _send(),
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: context.l10n.assistantComposerHint,
        filled: true,
        fillColor: context.colorScheme.surfaceContainerHighest,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm - AppSpacing.xxs,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onPressed});

  static const _duration = Duration(milliseconds: 200);

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isBotTyping = context.select((ChatbotCubit cubit) => cubit.state.isBotTyping);
    final isActive = enabled && !isBotTyping;
    final colors = context.colorScheme;
    final size = AppSizes.iconButtonSize;

    return Semantics(
      button: true,
      enabled: isActive,
      child: GestureDetector(
        onTap: isActive ? onPressed : null,
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.arrowUp,
            size: AppSizes.iconField,
            color: isActive ? colors.onPrimary : colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
