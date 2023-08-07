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
    with TickerProviderStateMixin {
  static const double boxWidth = 200;
  static const double boxHeight = 200;

  static const animationCurve = Curves.easeInOut;
  static const int animationDuration = 1000;
  static const int animationInterval = 100;

  bool didAnimate = false;
  bool isForward = false;

  final animationControllers = List<AnimationController>.empty(growable: true);

  late final AnimationController backgroundAnimationController;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 5; i++) {
      animationControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: animationDuration),
        ),
      );
    }

    backgroundAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds:
            animationDuration + animationControllers.length * animationInterval,
      ),
    );

    backgroundAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    for (AnimationController controller in animationControllers) {
      controller.dispose();
    }
    backgroundAnimationController.dispose();

    super.dispose();
  }

  void animateReverse() {
    didAnimate = false;
    isForward = false;

    animationControllers.elementAt(0).reverse();
    backgroundAnimationController.reverse();

    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) {
        if (!isForward) {
          animationControllers.elementAt(1).reverse();

          Future.delayed(const Duration(milliseconds: 100)).then(
            (value) {
              if (!isForward) {
                animationControllers.elementAt(2).reverse();

                Future.delayed(const Duration(milliseconds: 100)).then(
                  (value) {
                    if (!isForward) {
                      animationControllers.elementAt(3).reverse();

                      Future.delayed(const Duration(milliseconds: 100)).then(
                        (value) {
                          if (!isForward) {
                            animationControllers.elementAt(4).reverse();
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  void animateForward() {
    didAnimate = true;
    isForward = true;

    animationControllers.elementAt(0).forward();
    backgroundAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 100)).then(
      (value) {
        if (isForward) {
          animationControllers.elementAt(1).forward();

          Future.delayed(const Duration(milliseconds: 100)).then(
            (value) {
              if (isForward) {
                animationControllers.elementAt(2).forward();

                Future.delayed(const Duration(milliseconds: 100)).then(
                  (value) {
                    if (isForward) {
                      animationControllers.elementAt(3).forward();

                      Future.delayed(const Duration(milliseconds: 100)).then(
                        (value) {
                          if (isForward) {
                            animationControllers.elementAt(4).forward();
                          }
                        },
                      );
                    }
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTween(
        begin: Colors.white,
        end: Colors.black87,
      )
          .chain(CurveTween(curve: animationCurve))
          .evaluate(backgroundAnimationController),
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
              animateReverse();
            } else {
              animateForward();
            }
          },
        ),
      ),
    );
  }

  Widget _buildTextLayer() {
    return RotateAnimationWidget(
      y: -300,
      animationController: animationControllers.elementAt(0),
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
                .evaluate(animationControllers.elementAt(0))!,
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
                .evaluate(animationControllers.elementAt(0))!,
          ),
        ),
      ),
    );
  }

  Widget _buildPaddingLayer() {
    return RotateAnimationWidget(
      y: -225,
      animationController: animationControllers.elementAt(1),
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          border: Border.all(
            width: 30,
            color: ColorTween(begin: Colors.transparent, end: Colors.cyan)
                .chain(CurveTween(curve: animationCurve))
                .evaluate(animationControllers.elementAt(1))!,
          ),
        ),
      ),
    );
  }

  Widget _buildBorderLayer() {
    return RotateAnimationWidget(
      y: -150,
      animationController: animationControllers.elementAt(2),
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
    return RotateAnimationWidget(
      y: -75,
      animationController: animationControllers.elementAt(3),
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildShadowLayer() {
    return RotateAnimationWidget(
      y: 0,
      animationController: animationControllers.elementAt(4),
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
