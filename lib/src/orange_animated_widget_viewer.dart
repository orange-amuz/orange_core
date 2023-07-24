import 'package:flutter/material.dart';

class OrangeAnimatedWidgetViewer extends StatefulWidget {
  const OrangeAnimatedWidgetViewer({
    Key? key,
    this.isAnimate = false,
    this.animationDuration = const Duration(milliseconds: 850),
    this.maxTopMargin = 75.0,
    this.heightCurve = Curves.easeOutCubic,
    this.maxOpacity = 1.0,
    this.opacityCurve = Curves.easeOutCubic,
    this.child,
  }) : super(key: key);

  /// 애니메이션 사용 여부
  final bool isAnimate;

  /// 애니메이션 시간
  final Duration animationDuration;

  /// 나타나면서 위로 이동할 거리
  final double maxTopMargin;

  /// 위로 이동하면서 적용될 애니메이션 Curve
  final Curve heightCurve;

  /// 최대 투명도
  final double maxOpacity;

  /// 투명도가 변하면서 적용될 애니메이션 Curve
  final Curve opacityCurve;

  /// 애니메이션을 적용할 위젯
  final Widget? child;

  @override
  State<OrangeAnimatedWidgetViewer> createState() =>
      _OrangeAnimatedWidgetViewerState();
}

class _OrangeAnimatedWidgetViewerState extends State<OrangeAnimatedWidgetViewer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation _heightAnimation;
  late final Animation _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(_updateWidget);

    _heightAnimation = Tween(
      begin: widget.maxTopMargin,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.heightCurve,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.opacityCurve,
      ),
    );

    if (widget.isAnimate) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(_updateWidget);
    _animationController.dispose();

    super.dispose();
  }

  void _updateWidget() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant OrangeAnimatedWidgetViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimate != oldWidget.isAnimate) {
      if (widget.isAnimate) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacityAnimation.value,
      child: Container(
        margin: EdgeInsets.only(
          top: _heightAnimation.value,
        ),
        child: widget.child,
      ),
    );
  }
}
