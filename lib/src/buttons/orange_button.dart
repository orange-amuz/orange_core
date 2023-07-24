import 'package:flutter/material.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.child,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.onPressed,
  }) : super(key: key);

  /// 버튼의 상 / 하 / 좌 / 우 마진 값
  final EdgeInsets margin;

  /// 버튼의 상 / 하 / 좌 / 우 패딩 값
  final EdgeInsets padding;

  /// 자식 위젯 (버튼)
  final Widget? child;

  /// HitTestBehavior, [GestureDetector] 참고
  final HitTestBehavior hitTestBehavior;

  /// 버튼을 길게 눌렸을 때 실행될 메서드
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Container(
          padding: padding,
          margin: margin,
          child: GestureDetector(
            behavior: hitTestBehavior,
            onTap: onPressed,
            child: child,
          ),
        );
      },
    );
  }
}
