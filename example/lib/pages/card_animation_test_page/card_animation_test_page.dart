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

  double alignX = 0;
  double alignY = 0;
  double rotateAngle = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                // if (details.localPosition.dx > constraints.maxWidth / 2) {
                //   setTargetLeft();
                //   animationController.forward();
                // } else {
                //   setTargetRight();
                //   animationController.forward();
                // }

                setCurveForward();
                animationController.forward();
              },
              onTapUp: (details) {
                setCurveReverse();
                animationController.reverse();
              },
              onTapCancel: () {
                setCurveReverse();
                animationController.reverse();
              },
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(
                      Tween(
                        begin: 0.0,
                        end: math.pi / 6,
                      )
                          .chain(CurveTween(curve: curve))
                          .evaluate(animationController)
                          .toDouble(),
                    ),
                  child: Transform.rotate(
                    angle: math.pi / 12 * 5,
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
                          colors: const [Colors.white, Colors.red],
                          stops: const [0, 1],
                          center: Alignment(
                            Tween(begin: 1.0, end: -1.0)
                                    .chain(CurveTween(curve: curve))
                                    .evaluate(animationController)
                                    .toDouble() *
                                math.cos(math.pi / 6),
                            Tween(begin: -2.0, end: 2.0)
                                    .chain(CurveTween(curve: curve))
                                    .evaluate(animationController)
                                    .toDouble() *
                                math.cos(math.pi / 6),
                          ),
                        ),
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
                                width: 30,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[700],
                                  borderRadius: BorderRadius.circular(5),
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
