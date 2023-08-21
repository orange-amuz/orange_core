import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppleWatchPainter extends CustomPainter {
  AppleWatchPainter({
    required this.firstAngle,
    required this.secondAngle,
    required this.thirdAngle,
    this.strokeWidth = 15,
    this.centerWidth = 5,
    this.padding = 2,
  });

  final double strokeWidth;

  final double padding;
  final double centerWidth;

  final double firstAngle;
  final double secondAngle;
  final double thirdAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final outSidePaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    final firstPaint = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final secondPaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final thirdPaint = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    canvas.drawCircle(
      center,
      strokeWidth + (strokeWidth + padding) * 3,
      outSidePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(
          center.dx,
          center.dy,
        ),
        radius: (strokeWidth + padding) * 3 + centerWidth,
      ),
      -math.pi / 2,
      firstAngle,
      false,
      firstPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(
          center.dx,
          center.dy,
        ),
        radius: (strokeWidth + padding) * 2 + centerWidth,
      ),
      -math.pi / 2,
      secondAngle,
      false,
      secondPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(
          center.dx,
          center.dy,
        ),
        radius: (strokeWidth + padding) * 1 + centerWidth,
      ),
      -math.pi / 2,
      thirdAngle,
      false,
      thirdPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
