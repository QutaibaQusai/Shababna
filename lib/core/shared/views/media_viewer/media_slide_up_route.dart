import 'package:flutter/material.dart';

PageRouteBuilder<void> mediaSlideUpRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, _, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}
