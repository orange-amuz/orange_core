import 'dart:math' as math;

import 'package:example/pages/apple_watch_animation_test_page/apple_watch_painter/apple_watch_painter.dart';
import 'package:flutter/material.dart';

class AppleWatchAnimationTestPage extends StatefulWidget {
  const AppleWatchAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<AppleWatchAnimationTestPage> createState() =>
      _AppleWatchAnimationTestPageState();
}

class _AppleWatchAnimationTestPageState
    extends State<AppleWatchAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 1000);
  static const animationCurve = Curves.easeInOut;

  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  final rnd = math.Random();

  int firstAngle = 0;
  int secondAngle = 0;
  int thirdAngle = 0;

  @override
  void initState() {
    super.initState();

    animationController.addListener(
      () {
        setState(() {});
      },
    );

    firstAngle = rnd.nextInt(13);
    secondAngle = rnd.nextInt(13);
    thirdAngle = rnd.nextInt(13);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              firstAngle = rnd.nextInt(13);
              secondAngle = rnd.nextInt(13);
              thirdAngle = rnd.nextInt(13);

              animationController.reset();
              animationController.forward();
            },
            icon: const Icon(
              Icons.restore,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: CustomPaint(
            painter: AppleWatchPainter(
              firstAngle: Tween(
                begin: 0,
                end: 2 * math.pi * firstAngle / 13,
              )
                  .chain(CurveTween(curve: animationCurve))
                  .evaluate(animationController)
                  .toDouble(),
              secondAngle: Tween(
                begin: 0,
                end: 2 * math.pi * secondAngle / 13,
              )
                  .chain(CurveTween(curve: animationCurve))
                  .evaluate(animationController)
                  .toDouble(),
              thirdAngle: Tween(
                begin: 0,
                end: 2 * math.pi * thirdAngle / 13,
              )
                  .chain(CurveTween(curve: animationCurve))
                  .evaluate(animationController)
                  .toDouble(),
            ),
          ),
        ),
      ),
    );
  }
}
