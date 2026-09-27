import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';

class ProfileCompletionBadge extends StatefulWidget {
  const ProfileCompletionBadge({super.key, required this.percentage});

  final int percentage;

  @override
  State<ProfileCompletionBadge> createState() => _ProfileCompletionBadgeState();
}

class _ProfileCompletionBadgeState extends State<ProfileCompletionBadge> {
  static const _pencilDuration = Duration(seconds: 1);
  static const _progressDuration = Duration(seconds: 3);
  static const _ringDuration = Duration(milliseconds: 1200);
  static const _switchDuration = Duration(milliseconds: 400);

  bool _showNumber = false;
  int _ringTarget = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _play();
  }

  @override
  void didUpdateWidget(ProfileCompletionBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) _play();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _play() {
    _timer?.cancel();
    _showNumber = false;
    _timer = Timer(_pencilDuration, () {
      if (!mounted) return;
      setState(() {
        _showNumber = true;
        _ringTarget = widget.percentage;
      });
      _timer = Timer(_progressDuration, () {
        if (!mounted) return;
        setState(() => _showNumber = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.profileBadgeSize,
      height: AppSizes.profileBadgeSize,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _ringTarget.toDouble()),
        duration: _ringDuration,
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 3,
                  backgroundColor: context.colorScheme.surface,
                  color: context.colorScheme.primary,
                ),
              ),
              AnimatedSwitcher(
                duration: _switchDuration,
                child: _showNumber
                    ? Text(
                        '${value.round()}%',
                        key: const ValueKey('number'),
                        style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                      )
                    : Icon(
                        LucideIcons.pencilLine,
                        key: const ValueKey('pencil'),
                        size: AppSizes.iconSm,
                        color: context.colorScheme.onSurface,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
