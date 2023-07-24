import 'package:flutter/material.dart';

class OrangeListButton extends StatelessWidget {
  const OrangeListButton({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.animationDuration = Duration.zero,
    this.animationCurve = Curves.easeInOut,
    this.backgroundColor = const Color.fromRGBO(246, 246, 246, 1),
    this.child,
    this.onPressed,
  }) : super(key: key);

  /// 버튼의 상 / 하 / 좌 / 우 패딩 값
  final EdgeInsets padding;

  /// 애니메이션 시간
  final Duration animationDuration;

  /// 애니메이션 커브
  final Curve animationCurve;

  /// 버튼을 눌리고 있을 때 색
  final Color backgroundColor;

  /// 자식 위젯 (버튼)
  final Widget? child;

  /// 버튼을 눌렸을 때 실행될 메서드
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return MaterialButton(
          animationDuration: animationDuration,
          elevation: 0,
          hoverElevation: 0,
          focusElevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          highlightColor: backgroundColor,
          splashColor: Colors.transparent,
          padding: padding,
          onPressed: onPressed,
          child: child,
        );
      },
    );
  }
}
