import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin {
  CustomPageRoute({
    required this.builder,
    required this.key,
    this.maintainState = true,
  }) : assert(
          !(key.currentContext == null),
          'Key must attached to base Widget',
        );

  final WidgetBuilder builder;

  final GlobalKey key;

  bool arrivedCompleted = false;
  AnimationStatus beforeStatus = AnimationStatus.dismissed;

  bool dismissUseGesture = false;
  bool isLastFrame = false;

  late final renderBox = key.currentContext!.findRenderObject() as RenderBox;

  late final offset = renderBox.localToGlobal(Offset.zero);
  late final size = renderBox.size;

  static const animationCurve = Curves.easeInOut;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) => false;

  @override
  final bool maintainState;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = Theme.of(context).pageTransitionsTheme;

    switch (animation.status) {
      case AnimationStatus.completed:
        if (beforeStatus == AnimationStatus.forward) {
          arrivedCompleted = true;
        }

      default:
        beforeStatus = animation.status;
        break;
    }

    if ((arrivedCompleted)) {
      if (beforeStatus == AnimationStatus.forward) {
        isLastFrame = true;
      } else if (beforeStatus == AnimationStatus.reverse) {
        isLastFrame = false;
      }

      if (navigator?.userGestureInProgress == true) {
        isLastFrame = true;
      }

      if (isLastFrame) {
        return theme.buildTransitions<T>(
          this,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final width = Tween<double>(
      begin: math.min(size.width, screenWidth),
      end: screenWidth,
    ).chain(CurveTween(curve: animationCurve)).transform(animation.value);

    final height = Tween<double>(
      begin: math.min(size.height, screenHeight),
      end: screenHeight,
    ).chain(CurveTween(curve: animationCurve)).transform(animation.value);

    final marginTop = Tween<double>(
      begin: offset.dy,
      end: 0,
    ).chain(CurveTween(curve: animationCurve)).transform(animation.value);

    final marginLeft = Tween<double>(
      begin: offset.dx,
      end: 0,
    ).chain(CurveTween(curve: animationCurve)).transform(animation.value);

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(
            top: marginTop,
            left: marginLeft,
          ),
          child: OverflowBox(
            child: child,
          ),
        ),
      ),
    );
  }
}
