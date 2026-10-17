import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppBottomSafeArea extends StatelessWidget {
  const AppBottomSafeArea({super.key, this.top = false, required this.child});

  static const _iosInsetFactor = 0.5;

  final bool top;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    final bottom = defaultTargetPlatform == TargetPlatform.iOS
        ? inset * _iosInsetFactor
        : inset;

    final content = Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: child,
      ),
    );

    return top ? SafeArea(bottom: false, child: content) : content;
  }
}
