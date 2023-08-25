import 'dart:math' as math;
import 'package:flutter/material.dart';

class SquareAnimationTestPage extends StatefulWidget {
  const SquareAnimationTestPage({super.key});

  @override
  State<SquareAnimationTestPage> createState() =>
      _SquareAnimationTestPageState();
}

class _SquareAnimationTestPageState extends State<SquareAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  final Tween<double> angleTween = Tween(
    begin: 15 * math.pi / 180,
    end: -15 * math.pi / 180,
  );

  final ColorTween colorTween = ColorTween(
    begin: Colors.orange,
    end: Colors.red,
  );

  final Tween<double> borderRadiusTween = Tween(
    begin: 15,
    end: 0,
  );

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final squareSize = constraints.maxHeight * 0.3;

            return Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.7,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (_, child) {
                        final angle = angleTween
                            .chain(CurveTween(curve: animationCurve))
                            .transform(
                              animationController.value,
                            );

                        final color = colorTween
                            .chain(CurveTween(curve: animationCurve))
                            .transform(
                              animationController.value,
                            );

                        final borderRadius = borderRadiusTween
                            .chain(CurveTween(curve: animationCurve))
                            .transform(
                              animationController.value,
                            );

                        return Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: squareSize,
                            height: squareSize,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(borderRadius),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: MaterialButton(
                      child: const Text('toggle'),
                      onPressed: () {
                        if ([
                          AnimationStatus.dismissed,
                          AnimationStatus.reverse,
                        ].contains(animationController.status)) {
                          animationController.forward();
                        } else if ([
                          AnimationStatus.completed,
                          AnimationStatus.forward,
                        ].contains(animationController.status)) {
                          animationController.reverse();
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
