import 'dart:async';

import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import 'app_button.dart';

class AppCooldownTimer extends StatefulWidget {
  const AppCooldownTimer({
    super.key,
    required this.label,
    required this.onPressed,
    this.cooldownSeconds = 60,
  });

  final String label;
  final VoidCallback onPressed;
  final int cooldownSeconds;

  @override
  State<AppCooldownTimer> createState() => _AppCooldownTimerState();
}

class _AppCooldownTimerState extends State<AppCooldownTimer> {
  Timer? _timer;
  late int _secondsLeft = widget.cooldownSeconds;

  @override
  void initState() {
    super.initState();
    _startTicking();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  void _handlePressed() {
    widget.onPressed();
    setState(() => _secondsLeft = widget.cooldownSeconds);
    _startTicking();
  }

  @override
  Widget build(BuildContext context) {
    final isCoolingDown = _secondsLeft > 0;

    return SizedBox(
      height: AppSizes.cooldownTimerSize,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isCoolingDown
            ? SizedBox(
                key: const ValueKey('cooldown'),
                width: AppSizes.cooldownTimerSize,
                height: AppSizes.cooldownTimerSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _secondsLeft / widget.cooldownSeconds,
                      strokeWidth: 3,
                      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
                    ),
                    Text(
                      '$_secondsLeft',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              )
            : AppButton.text(
                key: const ValueKey('resend'),
                label: widget.label,
                onPressed: _handlePressed,
              ),
      ),
    );
  }
}
