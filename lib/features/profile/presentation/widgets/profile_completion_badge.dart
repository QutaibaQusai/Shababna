import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';

class ProfileCompletionBadge extends StatefulWidget {
  const ProfileCompletionBadge({super.key, required this.percentage});

  final int percentage;

  @override
  State<ProfileCompletionBadge> createState() => _ProfileCompletionBadgeState();
}

class _ProfileCompletionBadgeState extends State<ProfileCompletionBadge> {
  static const _pencilDuration = Duration(seconds: 1);
  static const _progressDuration = Duration(seconds: 3);

  bool _showProgress = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_pencilDuration, () {
      if (!mounted) return;
      setState(() => _showProgress = true);
      _timer = Timer(_progressDuration, () {
        if (!mounted) return;
        setState(() => _showProgress = false);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _showProgress
          ? _CompletionProgress(
              key: const ValueKey('progress'),
              percentage: widget.percentage,
            )
          : _PencilBadge(key: const ValueKey('pencil')),
    );
  }
}

class _PencilBadge extends StatelessWidget {
  const _PencilBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.profileBadgeSize,
      height: AppSizes.profileBadgeSize,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(
        LucideIcons.pencilLine,
        size: AppSizes.iconSm,
        color: context.colorScheme.onSurface,
      ),
    );
  }
}

class _CompletionProgress extends StatelessWidget {
  const _CompletionProgress({super.key, required this.percentage});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.profileBadgeSize,
      height: AppSizes.profileBadgeSize,
      child: TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: percentage),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value / 100,
                strokeWidth: 3,
                backgroundColor: context.colorScheme.surfaceContainerHighest,
                color: context.colorScheme.primary,
              ),
              Text(
                '$value%',
                style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}
