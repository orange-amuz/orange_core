import 'dart:math' as math;

import 'package:flutter/material.dart';

class CardAnimationTestPage extends StatefulWidget {
  const CardAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<CardAnimationTestPage> createState() => _CardAnimationTestPage();
}

class _CardAnimationTestPage extends State<CardAnimationTestPage>
    with SingleTickerProviderStateMixin {
  bool isForward = false;

  static const cardAngle = math.pi / 12 * 5;

  double xAngle = 0.0;
  double yAngle = 0.0;
  double zAngle = 0.0;

  double xAlign = 0;
  double yAlign = 0;

  // double rotateAngle = 0;

  Curve curve = Curves.easeInOut;

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();

    animationController.reverseDuration = const Duration(milliseconds: 1000);

    animationController.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
  }

  // void setTargetLeft() {
  //   alignX = -1.0;
  //   alignY = 2.0;
  //   rotateAngle = math.pi / 6;
  // }

  // void setTargetRight() {
  //   alignX = 1.0;
  //   alignY = -2.0;
  //   rotateAngle = -math.pi / 6;
  // }

  void setCurveForward() {
    curve = Curves.easeInOut;
  }

  void setCurveReverse() {
    curve = Curves.bounceOut.flipped;
  }

  void updateValueForward({
    required BoxConstraints constraints,
    required double x,
    required double y,
  }) {
    final center = Offset(
      constraints.maxWidth / 2,
      constraints.maxHeight / 2,
    );

    final relativeOffset = Offset(
      x - center.dx,
      y - center.dy,
    );

    final dx = relativeOffset.dx;
    final dy = relativeOffset.dy;

    final angle = -math.atan2(dy, dx) < 0
        ? -math.atan2(dy, dx) + math.pi * 2
        : -math.atan2(dy, dx);

    xAlign = -1.4 * math.cos(angle + cardAngle);
    yAlign = 1.2 * math.sin(angle + cardAngle);

    xAngle = -math.pi / 6 * math.cos(angle + cardAngle);
    yAngle = math.pi / 6 * math.sin(angle + cardAngle);
    // zAngle = -math.pi / 6 * math.tan(angle + cardAngle);

    // print('$xAngle, $yAngle');

    curve = Curves.easeInOut;

    animationController.forward();
  }

  void updateValueReverse() {
    curve = Curves.bounceOut.flipped;

    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Card Animation Test Page'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                updateValueForward(
                  constraints: constraints,
                  x: details.localPosition.dx,
                  y: details.localPosition.dy,
                );
              },
              onPanUpdate: (details) {
                setState(() {
                  updateValueForward(
                    constraints: constraints,
                    x: details.localPosition.dx,
                    y: details.localPosition.dy,
                  );
                });
              },
              onPanCancel: () {
                updateValueReverse();
              },
              onPanEnd: (details) {
                updateValueReverse();
              },
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    ..rotateX(
                      Tween(
                        begin: 0.0,
                        end: -xAngle,
                      )
                          .chain(CurveTween(curve: curve))
                          .evaluate(animationController)
                          .toDouble(),
                    )
                    ..rotateY(
                      Tween(
                        begin: 0.0,
                        end: -yAngle,
                      )
                          .chain(CurveTween(curve: curve))
                          .evaluate(animationController),
                    ),
                  child: Transform.rotate(
                    angle: cardAngle,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          radius: Tween(begin: 1.5, end: 1.5)
                              .chain(CurveTween(curve: Curves.easeInOut))
                              .evaluate(animationController)
                              .toDouble(),
                          colors: [
                            Colors.red.shade100,
                            Colors.red.shade200,
                            Colors.red,
                            Colors.red.shade800,
                            Colors.red.shade900,
                          ],
                          stops: const [
                            0,
                            0.15,
                            0.5,
                            0.85,
                            1.0,
                          ],
                          center: Alignment(
                            Tween(begin: 0, end: xAlign)
                                .chain(CurveTween(curve: curve))
                                .evaluate(animationController)
                                .toDouble(),
                            Tween(begin: 0, end: yAlign)
                                .chain(CurveTween(curve: curve))
                                .evaluate(animationController)
                                .toDouble(),
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.black,
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 20,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 35,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // gradient: RadialGradient(
                                  //   radius: Tween(begin: 1.5, end: 1.5)
                                  //       .chain(
                                  //           CurveTween(curve: Curves.easeInOut))
                                  //       .evaluate(animationController)
                                  //       .toDouble(),
                                  //   colors: [
                                  //     Colors.yellow.shade100,
                                  //     Colors.yellow.shade200,
                                  //     Colors.yellow,
                                  //     Colors.yellow.shade800,
                                  //     Colors.yellow.shade900,
                                  //   ],
                                  //   stops: const [
                                  //     0,
                                  //     0.15,
                                  //     0.5,
                                  //     0.85,
                                  //     1.0,
                                  //   ],
                                  //   center: Alignment(
                                  //     Tween(
                                  //       begin: -(35 / 2 + 95) / 300,
                                  //       end: xAlign + -(35 / 2 + 95) / 300,
                                  //     )
                                  //         .chain(CurveTween(curve: curve))
                                  //         .evaluate(animationController)
                                  //         .toDouble(),
                                  //     Tween(begin: 0, end: yAlign)
                                  //         .chain(CurveTween(curve: curve))
                                  //         .evaluate(animationController)
                                  //         .toDouble(),
                                  //   ),
                                  // ),
                                  color: Colors.yellow.shade800,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 20,
                            left: 20,
                            child: Text(
                              'JANG JUHWAN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color.fromRGBO(0, 0, 0, 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
