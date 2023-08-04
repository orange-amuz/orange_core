import 'dart:math' as math;

import 'package:flutter/material.dart';

class AnimationTestPage extends StatefulWidget {
  const AnimationTestPage({Key? key}) : super(key: key);

  @override
  State<AnimationTestPage> createState() => _AnimationTestPage();
}

class _AnimationTestPage extends State<AnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const double boxWidth = 200;
  static const double boxHeight = 200;

  static const double xAngle = math.pi / 4;
  static const double zAngle = math.pi / 4;

  static const animationCurve = Curves.easeInOut;
  static const animationDuration = Duration(milliseconds: 500);

  bool didAnimate = false;

  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  @override
  void initState() {
    super.initState();

    animationController.addListener(
      () {
        setState(() {});
      },
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
      backgroundColor: ColorTween(
        begin: Colors.white,
        end: Colors.black87,
      ).chain(CurveTween(curve: animationCurve)).evaluate(animationController),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Center(
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
              didAnimate = false;
              animationController.reverse();
            } else {
              didAnimate = true;
              animationController.forward();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextLayer() {
    return _buildCustomTranslateWidget(
      y: -300,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ColorTween(
              begin: Colors.transparent,
              end: Colors.grey,
            )
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)!,
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
            )
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)!,
          ),
        ),
      ),
    );
  }

  Widget _buildPaddingLayer() {
    return _buildCustomTranslateWidget(
      y: -225,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 30,
            color: ColorTween(begin: Colors.transparent, end: Colors.cyan)
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)!,
          ),
        ),
      ),
    );
  }

  Widget _buildBorderLayer() {
    return _buildCustomTranslateWidget(
      y: -150,
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
    return _buildCustomTranslateWidget(
      y: -75,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildShadowLayer() {
    return _buildCustomTranslateWidget(
      y: 0,
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

  //----------------------------------------------------------------------------

  Widget _buildCustomTranslateWidget({
    required double y,
    required Widget child,
  }) {
    return Transform.translate(
      offset: Offset(
        0.0,
        Tween(begin: 0.0, end: y)
            .chain(CurveTween(curve: animationCurve))
            .evaluate(animationController)
            .toDouble(),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(
            Tween(
              begin: 0.0,
              end: xAngle,
            )
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)
                .toDouble(),
          )
          ..rotateZ(
            Tween(
              begin: 0.0,
              end: zAngle,
            )
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)
                .toDouble(),
          )
          ..translate(
            Tween(
              begin: 0.0,
              end: boxWidth * math.cos(zAngle),
            )
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationController)
                .toDouble(),
          ),
        child: child,
      ),
    );
  }
}
