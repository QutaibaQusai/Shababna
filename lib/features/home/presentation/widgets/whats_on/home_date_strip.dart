import 'package:flutter/material.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_svg_icon.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../shared/home_formatters.dart';

class HomeDateStrip extends StatelessWidget {
  const HomeDateStrip({
    super.key,
    required this.days,
    required this.selected,
    required this.occasionDays,
    required this.onSelected,
  });

  final List<DateTime> days;
  final DateTime selected;
  final Set<DateTime> occasionDays;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.homeDateCellHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: days.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final day = days[index];
          return _DayCell(
            day: day,
            isToday: index == 0,
            isSelected: DateUtils.isSameDay(day, selected),
            hasOccasion: occasionDays.contains(day),
            onTap: () => onSelected(day),
          );
        },
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasOccasion,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 200);

  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool hasOccasion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final outlineColor = hasOccasion && reduceMotion
        ? colors.primary
        : colors.outlineVariant;
    final numberColor = isSelected ? colors.onPrimary : colors.onSurface;
    final labelColor = isSelected ? colors.primary : colors.onSurfaceVariant;

    final heart = SizedBox.square(
      dimension: AppSizes.homeDateHeartSize,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: _duration,
            child: AppSvgIcon(
              key: ValueKey(isSelected),
              asset: isSelected
                  ? AppAssets.iconAssociationHeartFilled
                  : AppAssets.iconAssociationHeart,
              size: AppSizes.homeDateHeartSize,
              color: isSelected ? colors.primary : outlineColor,
            ),
          ),
          Center(
            child: AnimatedDefaultTextStyle(
              duration: _duration,
              style: context.textTheme.titleMedium!.copyWith(
                color: numberColor,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              ),
              child: Text(HomeFormatters.dayOfMonth(context, day)),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: SizedBox(
          width: AppSizes.homeDateCellWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isToday
                    ? context.l10n.homeToday
                    : HomeFormatters.weekday(context, day),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.xxs),
              if (hasOccasion && !reduceMotion)
                _HeartPulse(child: heart)
              else
                heart,
            ],
          ),
        ),
      ),
    );
  }
}

class _HeartPulse extends StatefulWidget {
  const _HeartPulse({required this.child});

  final Widget child;

  @override
  State<_HeartPulse> createState() => _HeartPulseState();
}

class _HeartPulseState extends State<_HeartPulse>
    with SingleTickerProviderStateMixin {
  static const _period = Duration(milliseconds: 1400);
  static final _beat = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 1.15,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.15,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 12,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 1.08,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 10,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.08,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeIn)),
      weight: 12,
    ),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 54),
  ]);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
    value: _syncedPhase(),
  )..repeat();

  late final Animation<double> _scale = _beat.animate(_controller);

  static double _syncedPhase() {
    final periodMs = _period.inMilliseconds;
    return (DateTime.now().millisecondsSinceEpoch % periodMs) / periodMs;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
