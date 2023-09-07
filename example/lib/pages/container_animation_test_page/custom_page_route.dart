import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin {
  CustomPageRoute({
    required this.builder,
    // required this.key,
    required this.initialWidth,
    required this.initialHeight,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  final double initialWidth;
  final double initialHeight;

  // final Key key;

  bool arrivedCompleted = false;
  AnimationStatus beforeStatus = AnimationStatus.dismissed;

  bool dismissUseGesture = true;

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
      if (beforeStatus == AnimationStatus.forward ||
          beforeStatus == AnimationStatus.completed) {
        return theme.buildTransitions<T>(
          this,
          context,
          animation,
          secondaryAnimation,
          child,
        );
        // if (navigator?.userGestureInProgress ?? true) {
        // } else {
        //   if (beforeStatus == AnimationStatus.completed) {
        //   } else {
        //     dismissUseGesture = false;
        //     print('dismissUseGesture to false at ${DateTime.now()}');
        //   }
        // }

        // if (dismissUseGesture) {}
      }
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final width = Tween<double>(
      begin: math.min(initialWidth, screenWidth),
      end: screenWidth,
    ).transform(animation.value);

    final height = Tween<double>(
      begin: math.min(initialHeight, screenHeight),
      end: screenHeight,
    ).transform(animation.value);

    return SizedBox(
      width: screenWidth,
      height: screenHeight,
      child: Center(
        child: OverflowBox(
          child: SizedBox(
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );

    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    // final width = Tween<double>(
    //   begin: math.min(initialWidth, screenWidth),
    //   end: screenWidth,
    // ).transform(animation.value);

    // final height = Tween<double>(
    //   begin: math.min(initialHeight, screenHeight),
    //   end: screenHeight,
    // ).transform(animation.value);

    // return SizedBox(
    //   width: screenWidth,
    //   height: screenHeight,
    //   child: Center(
    //     child: SizedBox(
    //       width: width,
    //       height: height,
    //       child: child,
    //     ),
    //   ),
    // );

    // return theme.buildTransitions<T>(
    //   this,
    //   context,
    //   animation,
    //   secondaryAnimation,
    //   child,
    // );
  }
}
