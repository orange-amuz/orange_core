import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CardAnimationTestPage extends StatefulWidget {
  const CardAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<CardAnimationTestPage> createState() => _CardAnimationTestPage();
}

class _CardAnimationTestPage extends State<CardAnimationTestPage>
    with TickerProviderStateMixin {
  bool isForward = false;

  static const cardAngle = math.pi / 12 * 5;

  BoxConstraints constraints = const BoxConstraints();

  double xAngle = 0.0;
  double yAngle = 0.0;
  // double zAngle = 0.0;

  double xAlign = 0;
  double yAlign = 0;

  double beforeX = 0;
  double beforeY = 0;

  Curve curve = Curves.easeInOut;

  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final initialAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  late final repeatAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
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

    initialAnimationController.addListener(
      () {
        setState(() {});
      },
    );

    repeatAnimationController.addListener(
      () {
        setState(() {});
      },
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        initialAnimationController.forward();
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    initialAnimationController.dispose();

    repeatAnimationController.dispose();

    super.dispose();
  }

  void setCurveForward() {
    curve = Curves.easeInOut;
  }

  void setCurveReverse() {
    curve = Curves.bounceOut.flipped;
  }

  // Future<void> updateValueForwardGyro({
  //   required double x,
  //   required double y,
  // }) async {
  //   // final center = Offset(
  //   //   constraints.maxWidth / 2,
  //   //   constraints.maxHeight / 2,
  //   // );

  //   final relativeOffset = Offset(
  //     x,
  //     y,
  //   );

  //   final dx = relativeOffset.dx;
  //   final dy = relativeOffset.dy;

  //   final angle = -math.atan2(dy, dx) < 0
  //       ? -math.atan2(dy, dx) + math.pi * 2
  //       : -math.atan2(dy, dx);

  //   xAlign = -1.4 * math.cos(angle + cardAngle);
  //   yAlign = 1.2 * math.sin(angle + cardAngle);

  //   xAngle = -math.pi / 6 * math.cos(angle + cardAngle);
  //   yAngle = math.pi / 6 * math.sin(angle + cardAngle);
  //   // zAngle = -math.pi / 6 * math.tan(angle + cardAngle);

  //   // print('$xAngle, $yAngle');

  //   curve = Curves.easeInOut;

  //   await animationController.forward();
  // }

  Future<void> updateValueForward({
    required BoxConstraints constraints,
    required double x,
    required double y,
  }) async {
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

    curve = Curves.easeInOut;

    await animationController.forward();
  }

  Future<void> updateValueReverse() async {
    curve = Curves.bounceOut.flipped;

    await animationController.reverse();
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
            this.constraints = constraints;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                updateValueForward(
                  constraints: constraints,
                  x: details.localPosition.dx,
                  y: details.localPosition.dy,
                );

                initialAnimationController.reverse();
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

                initialAnimationController.forward();
              },
              onPanEnd: (details) {
                updateValueReverse();

                initialAnimationController.forward();
              },
              child: Stack(
                children: [
                  _buildBackLargeLogo(),
                  _buildBackSmallLogo(),
                  _buildFilter(),
                  _buildCard(),
                  _buildFrontSmallLogo(),
                  _buildFrontLargeLogo(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackLargeLogo() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            Tween(begin: 0.0, end: 100.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.0, end: 200.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            0.0,
          )
          ..scale(
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            1,
          ),
        child: Transform.rotate(
          angle: math.pi / 5,
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            child: const FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackSmallLogo() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            Tween(begin: 0.0, end: -100.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.0, end: -200.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            0.0,
          )
          ..scale(
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            1,
          ),
        child: Transform.rotate(
          angle: -math.pi / 5,
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            child: const FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 3,
        sigmaY: 3,
      ),
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildFrontSmallLogo() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            Tween(begin: 0.0, end: 100.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.0, end: -130.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            0.0,
          )
          ..scale(
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            1,
          ),
        child: Transform.rotate(
          angle: math.pi + (math.pi / 5),
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            child: const FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontLargeLogo() {
    return Center(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            Tween(begin: 0.0, end: -90.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.0, end: 130.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            0.0,
          )
          ..scale(
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            Tween(begin: 0.5, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            1,
          ),
        child: Transform.rotate(
          angle: -math.pi / 25,
          child: Opacity(
            opacity: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(initialAnimationController)
                .toDouble(),
            child: const FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Center(
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
            ).chain(CurveTween(curve: curve)).evaluate(animationController),
          ),
        child: Transform.rotate(
          angle: cardAngle,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return RadialGradient(
                radius: Tween(begin: 1.5, end: 1.5)
                    .chain(CurveTween(curve: Curves.easeInOut))
                    .evaluate(animationController)
                    .toDouble(),
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.2),
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
              ).createShader(bounds);
            },
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
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
  }
}
