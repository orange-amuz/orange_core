import 'dart:math' as math;
import 'package:flutter/material.dart';

class SwingAnimationTestPage extends StatefulWidget {
  const SwingAnimationTestPage({super.key});

  @override
  State<SwingAnimationTestPage> createState() => _SwingAnimationTestPageState();
}

class _SwingAnimationTestPageState extends State<SwingAnimationTestPage>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
    lowerBound: (size.width + 100) * -1,
    upperBound: (size.width + 100),
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  int index = 0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;

    if (_position.value.abs() >= bound) {
      if (_position.value.isNegative) {
        _position
            .animateTo(
              -(size.width + 100),
              curve: Curves.easeInOut,
            )
            .whenComplete(
              whenComplete,
            );
      } else {
        _position
            .animateTo(
              size.width + 100,
              curve: Curves.easeInOut,
            )
            .whenComplete(
              whenComplete,
            );
      }
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeInOut,
      );
    }
  }

  void whenComplete() {
    _position.value = 0;
    setState(() {
      index = index == 4 ? 0 : index + 1;
    });
  }

  @override
  void dispose() {
    _position.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Swing Animation Test Page'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (_, child) {
          final ratio = (_position.value + (size.width / 2)) / size.width;

          final angle = _rotation.transform(
                ratio,
              ) *
              math.pi /
              180;

          final scale = _scale.transform(
            (_position.value.abs() / size.width).clamp(
              0.0,
              1.0,
            ),
          );

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: scale,
                  child: Card(
                    index: index == 4 ? 0 : index + 1,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: index,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  Card({
    super.key,
    required this.index,
  });

  final int index;

  final icons = [
    Icons.abc,
    Icons.menu,
    Icons.play_arrow,
    Icons.back_hand,
    Icons.access_alarm,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Center(
          child: Icon(
            icons.elementAt(index),
          ),
        ),
      ),
    );
  }
}
