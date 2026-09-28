import 'package:flutter/widgets.dart';

class ItemSnapScrollPhysics extends ScrollPhysics {
  const ItemSnapScrollPhysics({required this.itemExtent, super.parent});

  final double itemExtent;

  @override
  ItemSnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ItemSnapScrollPhysics(itemExtent: itemExtent, parent: buildParent(ancestor));
  }

  double _targetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    var item = position.pixels / itemExtent;
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return (item.roundToDouble() * itemExtent)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final atStart = velocity <= 0 && position.pixels <= position.minScrollExtent;
    final atEnd = velocity >= 0 && position.pixels >= position.maxScrollExtent;
    if (atStart || atEnd) return super.createBallisticSimulation(position, velocity);

    final tolerance = toleranceFor(position);
    final target = _targetPixels(position, tolerance, velocity);
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }

  @override
  bool get allowImplicitScrolling => false;
}
