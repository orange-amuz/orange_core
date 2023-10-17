import 'package:flutter/material.dart';

class MetaBall extends StatefulWidget {
  const MetaBall({
    super.key,
    required this.offset,
    required this.blobSize,
    required this.color,
  });

  final Offset offset;
  final double blobSize;
  final Color color;

  @override
  State<MetaBall> createState() => _MetaBallState();
}

class _MetaBallState extends State<MetaBall> {
  @override
  void didUpdateWidget(covariant MetaBall oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.offset.dx != widget.offset.dx ||
        oldWidget.offset.dy != widget.offset.dy) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.topLeft,
      transform: Matrix4.identity()
        ..translate(
          widget.offset.dx,
          widget.offset.dy,
        ),
      child: Container(
        width: widget.blobSize,
        height: widget.blobSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.blobSize / 2),
          color: widget.color,
        ),
      ),
    );
  }
}
