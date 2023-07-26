import 'package:flutter/material.dart';

class OrangeScaleButton extends StatefulWidget {
  const OrangeScaleButton({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.maxScale = 1.0,
    this.minScale = 0.95,
    this.animationDuration = const Duration(milliseconds: 150),
    this.animationCurve = Curves.easeInOut,
    this.child,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.onPressed,
    this.onLongPressed,
  }) : super(key: key);

  /// 버튼의 상 / 하 / 좌 / 우 마진 값
  final EdgeInsets margin;

  /// 버튼의 최대 크기 비율
  final double maxScale;

  /// 버튼의 최소 크기 비율
  final double minScale;

  /// 애니메이션 시간
  final Duration animationDuration;

  /// 애니메이션 커브
  final Curve animationCurve;

  /// 자식 위젯 (버튼)
  final Widget? child;

  /// HitTestBehavior, [GestureDetector] 참고
  final HitTestBehavior hitTestBehavior;

  /// 버튼을 눌렸을 때 실행될 메서드
  final void Function()? onPressed;

  /// 버튼을 길게 눌렸을 때 실행될 메서드
  final void Function()? onLongPressed;

  @override
  State<OrangeScaleButton> createState() => _OrangeScaleButtonState();
}

class _OrangeScaleButtonState extends State<OrangeScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(_updateWidget);

    _animation = Tween(
      begin: widget.maxScale,
      end: widget.minScale,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );
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
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: GestureDetector(
        onTapDown: (_) {
          if (mounted) {
            _animationController.forward();
          }
        },
        onTapUp: (_) {
          if (mounted) {
            _animationController.reverse();
          }
        },
        onTapCancel: () {
          if (mounted) {
            _animationController.reverse();
          }
        },
        onTap: widget.onPressed,
        onLongPress: widget.onLongPressed,
        child: Transform.scale(
          scale: _animation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
