import 'package:flutter/material.dart';

import 'dashboard_formatters.dart';

class DashboardCountUp extends StatelessWidget {
  const DashboardCountUp({
    super.key,
    required this.value,
    required this.style,
    this.decimals = 0,
    this.suffix = '',
  });

  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;
  static const _tabularFigures = [FontFeature.tabularFigures()];

  final num value;
  final TextStyle? style;
  final int decimals;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: reduceMotion ? Duration.zero : _duration,
      curve: _curve,
      builder: (context, current, _) {
        final shown = decimals == 0 ? current.roundToDouble() : current;
        return Text(
          '${DashboardFormatters.number(context, shown, decimals: decimals)}$suffix',
          maxLines: 1,
          textDirection: TextDirection.ltr,
          style: style?.copyWith(fontFeatures: _tabularFigures),
        );
      },
    );
  }
}
