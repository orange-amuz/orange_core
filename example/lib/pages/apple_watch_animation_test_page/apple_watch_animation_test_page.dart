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

  late Tween<double> firstTween = Tween(
    begin: 0,
    end: rnd.nextInt(360).toDouble(),
  );
  late Tween<double> secondTween = Tween(
    begin: 0,
    end: rnd.nextInt(360).toDouble(),
  );
  late Tween<double> thirdTween = Tween(
    begin: 0,
    end: rnd.nextInt(360).toDouble(),
  );

  @override
  void initState() {
    super.initState();

    animationController.animateTo(
      1,
      curve: animationCurve,
    );
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
              firstTween.end = rnd.nextInt(360).toDouble();
              secondTween.end = rnd.nextInt(360).toDouble();
              thirdTween.end = rnd.nextInt(360).toDouble();

              animationController.reset();

              animationController.animateTo(
                1,
                curve: animationCurve,
              );
            },
            icon: const Icon(
              Icons.restore,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: animationController,
            builder: (_, child) {
              final firstAngle = firstTween.transform(
                animationController.value,
              );

              final secondAngle = secondTween.transform(
                animationController.value,
              );

              final thirdAngle = thirdTween.transform(
                animationController.value,
              );

              return CustomPaint(
                painter: AppleWatchPainter(
                  firstAngle: firstAngle * math.pi / 180,
                  secondAngle: secondAngle * math.pi / 180,
                  thirdAngle: thirdAngle * math.pi / 180,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
