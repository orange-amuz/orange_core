import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateAnimationWidget extends StatelessWidget {
  const RotateAnimationWidget({
    Key? key,
    this.boxWidth = 200,
    this.boxHeight = 200,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 1000),
    required this.y,
    required this.animationValue,
    required this.child,
  }) : super(key: key);

  final double boxWidth;
  final double boxHeight;

  final Curve animationCurve;
  final Duration animationDuration;

  final double y;
  final double animationValue;
  final Widget child;

  static const double xAngle = math.pi / 4;
  static const double zAngle = math.pi / 4;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0.0,
        Tween(begin: 0.0, end: y)
            .chain(CurveTween(curve: animationCurve))
            .transform(animationValue)
            .toDouble(),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(
            Tween(
              begin: 0.0,
              end: RotateAnimationWidget.xAngle,
            )
                .chain(CurveTween(curve: animationCurve))
                .transform(animationValue)
                .toDouble(),
          )
          ..rotateZ(
            Tween(
              begin: 0.0,
              end: RotateAnimationWidget.zAngle,
            )
                .chain(CurveTween(curve: animationCurve))
                .transform(animationValue)
                .toDouble(),
          )
          ..translate(
            Tween(
              begin: 0.0,
              end: boxWidth * math.cos(RotateAnimationWidget.zAngle),
            )
                .chain(CurveTween(curve: animationCurve))
                .transform(animationValue)
                .toDouble(),
          ),
        child: child,
      ),
    );
  }
}
