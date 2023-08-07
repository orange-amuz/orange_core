import 'dart:math' as math;

import 'package:example/pages/dice_animation_test_page/cube/cube_side.dart';
import 'package:flutter/material.dart';

class CubeWidget extends StatelessWidget {
  const CubeWidget({
    Key? key,
    required this.x,
    required this.y,
  }) : super(key: key);

  final double x;
  final double y;

  static const double shadow = 0.2;
  static const halfPi = math.pi / 2;
  static const oneHalfPi = math.pi + (math.pi / 2);

  double get sum => (y + (x > math.pi ? math.pi : 0.0)).abs() % (math.pi * 2);

  double getShadow(double r) {
    if (r < halfPi) {
      return map(r, 0, halfPi, 0, shadow).toDouble();
    } else if (r > oneHalfPi) {
      return shadow - map(r, oneHalfPi, math.pi * 2, 0, shadow);
    } else if (r < math.pi) {
      return shadow - map(r, halfPi, math.pi, 0, shadow);
    }

    return map(r, math.pi, oneHalfPi, 0, shadow).toDouble();
  }

  num map(
    num value, [
    num iStart = 0,
    num iEnd = math.pi * 2,
    num oStart = 0,
    num oEnd = 1.0,
  ]) {
    return ((oEnd - oStart) / (iEnd - iStart)) * (value - iStart) + oStart;
  }

  @override
  Widget build(BuildContext context) {
    final bool topBottom = x < halfPi || x > oneHalfPi;
    final bool northSouth = sum < halfPi || sum > oneHalfPi;
    final bool eastWest = sum < math.pi;

    final faces = List<CubeSide>.empty(growable: true);

    faces.addAll(
      [
        CubeSide(
          zAngle: y,
          xAngle: -x,
          moveZ: topBottom,
          shadow: getShadow(x),
          num1: 1,
          num2: 6,
        ),
        CubeSide(
          yAngle: y,
          xAngle: halfPi - x,
          moveZ: northSouth,
          shadow: getShadow(sum),
          num1: 2,
          num2: 5,
        ),
        CubeSide(
          yAngle: -halfPi + y,
          xAngle: halfPi - x,
          moveZ: eastWest,
          shadow: shadow - getShadow(sum),
          num1: 3,
          num2: 4,
        ),
      ],
    );

    faces.sort(
      (a, b) {
        if (a.shadow > b.shadow) {
          return 1;
        }

        return -1;
      },
    );

    return Stack(
      children: faces.reversed.toList(),
    );
  }
}
