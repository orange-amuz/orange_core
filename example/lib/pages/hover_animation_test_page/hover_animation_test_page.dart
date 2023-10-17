import 'package:example/pages/hover_animation_test_page/rotate_animation_widget.dart';
import 'package:flutter/material.dart';

class HoverAnimationTestPage extends StatefulWidget {
  const HoverAnimationTestPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HoverAnimationTestPage> createState() => _HoverAnimationTestPage();
}

class _HoverAnimationTestPage extends State<HoverAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const double boxWidth = 200;
  static const double boxHeight = 200;

  static const animationCurve = Curves.easeInOut;
  static const int animationDuration = 1000;
  static const int animationInterval = 100;

  static const int layerNumber = 5;

  static const double limitValue = 5 / 10;
  static const double intervalValue = 0.1;

  bool didAnimate = false;
  bool isForward = false;

  late final AnimationController backgroundAnimationController;

  @override
  void initState() {
    super.initState();

    backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: animationDuration + layerNumber * animationInterval,
      ),
    );
  }

  @override
  void dispose() {
    backgroundAnimationController.dispose();

    super.dispose();
  }

  void animateReverse() {
    didAnimate = false;
    isForward = false;

    backgroundAnimationController.reverse();
  }

  void animateForward() {
    didAnimate = true;
    isForward = true;

    backgroundAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hover Animation Test Page'),
      ),
      body: AnimatedBuilder(
        animation: backgroundAnimationController,
        builder: (_, child) {
          final value = backgroundAnimationController.value;

          return Container(
            color: ColorTween(
              begin: Colors.white,
              end: Colors.black87,
            ).chain(CurveTween(curve: animationCurve)).transform(value),
            child: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(
                    bottom: 100,
                  ),
                  child: SizedBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Stack(
                      children: [
                        _buildTextLayer(),
                        _buildPaddingLayer(),
                        _buildBorderLayer(),
                        _buildBaseLayer(),
                        _buildShadowLayer(),
                      ].reversed.toList(),
                    ),
                  ),
                ),
                onTap: () {
                  if (didAnimate) {
                    animateReverse();
                  } else {
                    animateForward();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextLayer() {
    final double value =
        (backgroundAnimationController.value.clamp(0, limitValue) *
            1 /
            limitValue);

    return RotateAnimationWidget(
      y: -300,
      animationValue: value,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ColorTween(
              begin: Colors.transparent,
              end: Colors.grey,
            ).chain(CurveTween(curve: animationCurve)).transform(value)!,
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: Text(
          'My Name is ...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorTween(
              begin: Colors.black,
              end: Colors.grey,
            ).chain(CurveTween(curve: animationCurve)).transform(value)!,
          ),
        ),
      ),
    );
  }

  Widget _buildPaddingLayer() {
    final double value = (backgroundAnimationController.value - intervalValue)
            .clamp(0, limitValue) *
        1 /
        limitValue;

    return RotateAnimationWidget(
      y: -225,
      animationValue: value,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 30,
            color: ColorTween(begin: Colors.transparent, end: Colors.cyan)
                .chain(CurveTween(curve: animationCurve))
                .transform(value)!,
          ),
        ),
      ),
    );
  }

  Widget _buildBorderLayer() {
    final double value =
        (backgroundAnimationController.value - intervalValue * 2)
                .clamp(0, limitValue) *
            1 /
            limitValue;

    return RotateAnimationWidget(
      y: -150,
      animationValue: value,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }

  Widget _buildBaseLayer() {
    final double value =
        (backgroundAnimationController.value - intervalValue * 3)
                .clamp(0, limitValue) *
            1 /
            limitValue;

    return RotateAnimationWidget(
      y: -75,
      animationValue: value,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildShadowLayer() {
    final double value =
        (backgroundAnimationController.value - intervalValue * 4)
                .clamp(0, limitValue) *
            1 /
            limitValue;

    return RotateAnimationWidget(
      y: 0,
      animationValue: value,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 20,
              spreadRadius: 2,
              color: Colors.grey.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
