import 'dart:math' as math;

import 'package:flutter/material.dart';

class RotateAnimationWidget extends StatefulWidget {
  const RotateAnimationWidget({
    Key? key,
    this.boxWidth = 200,
    this.boxHeight = 200,
    this.animationCurve = Curves.easeInOut,
    this.animationDuration = const Duration(milliseconds: 1000),
    required this.y,
    required this.animationController,
    required this.child,
  }) : super(key: key);

  final double boxWidth;
  final double boxHeight;

  final Curve animationCurve;
  final Duration animationDuration;

  final double y;
  final AnimationController animationController;
  final Widget child;

  static const double xAngle = math.pi / 4;
  static const double zAngle = math.pi / 4;

  @override
  State<RotateAnimationWidget> createState() => _RotateAnimationWidget();
}

class _RotateAnimationWidget extends State<RotateAnimationWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.animationController.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();

    widget.animationController.removeListener(listener);
  }

  void listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0.0,
        Tween(begin: 0.0, end: widget.y)
            .chain(CurveTween(curve: widget.animationCurve))
            .evaluate(widget.animationController)
            .toDouble(),
      ),
      child: Transform(
        transform: Matrix4.identity()
          ..rotateX(
            Tween(
              begin: 0.0,
              end: RotateAnimationWidget.xAngle,
            )
                .chain(CurveTween(curve: widget.animationCurve))
                .evaluate(widget.animationController)
                .toDouble(),
          )
          ..rotateZ(
            Tween(
              begin: 0.0,
              end: RotateAnimationWidget.zAngle,
            )
                .chain(CurveTween(curve: widget.animationCurve))
                .evaluate(widget.animationController)
                .toDouble(),
          )
          ..translate(
            Tween(
              begin: 0.0,
              end: widget.boxWidth * math.cos(RotateAnimationWidget.zAngle),
            )
                .chain(CurveTween(curve: widget.animationCurve))
                .evaluate(widget.animationController)
                .toDouble(),
          ),
        child: widget.child,
      ),
    );
  }
}
