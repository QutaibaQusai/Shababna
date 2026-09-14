import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';

class OnboardingCurvedSheet extends StatelessWidget {
  final Widget child;

  const OnboardingCurvedSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final color = context.theme.scaffoldBackgroundColor;

    return Stack(
      children: [
        Positioned.fill(
          top: -30,
          child: CustomPaint(
            painter: _CurvePainter(color: color),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 60, 32, 0),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurvePainter extends CustomPainter {
  final Color color;

  _CurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double curveHeight = 50.0;

    path.moveTo(0, curveHeight);

    // Cubic bezier for smooth S-curve
    path.cubicTo(
      size.width * 0.25,
      0, // Control point 1 (up)
      size.width * 0.75,
      curveHeight * 2, // Control point 2 (down)
      size.width,
      curveHeight, // End point
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
