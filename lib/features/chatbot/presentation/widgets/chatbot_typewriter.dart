import 'dart:async';

import 'package:flutter/material.dart';

class ChatbotTypewriter extends StatefulWidget {
  const ChatbotTypewriter({
    super.key,
    required this.text,
    required this.animate,
    required this.style,
    required this.completedBuilder,
    this.onCompleted,
  });

  final String text;
  final bool animate;
  final TextStyle? style;
  final WidgetBuilder completedBuilder;
  final VoidCallback? onCompleted;

  @override
  State<ChatbotTypewriter> createState() => _ChatbotTypewriterState();
}

class _ChatbotTypewriterState extends State<ChatbotTypewriter> {
  static const _wordInterval = Duration(milliseconds: 32);
  static const _swapDuration = Duration(milliseconds: 180);
  static final _wordBoundary = RegExp(r'(?<=\s)');

  late final List<String> _words = widget.text.split(_wordBoundary);
  Timer? _timer;
  int _visibleWords = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    if (!widget.animate || _words.length <= 1) {
      _isComplete = true;
      return;
    }
    _timer = Timer.periodic(_wordInterval, (_) => _revealNextWord());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _revealNextWord() {
    if (!mounted) return;
    if (_visibleWords >= _words.length) {
      _timer?.cancel();
      setState(() => _isComplete = true);
      widget.onCompleted?.call();
      return;
    }
    setState(() => _visibleWords++);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _swapDuration,
      layoutBuilder: (current, previous) => Stack(
        alignment: AlignmentDirectional.topStart,
        children: [...previous, ?current],
      ),
      child: _isComplete
          ? KeyedSubtree(key: const ValueKey('complete'), child: widget.completedBuilder(context))
          : Text(
              _words.take(_visibleWords).join(),
              key: const ValueKey('typing'),
              style: widget.style,
            ),
    );
  }
}
