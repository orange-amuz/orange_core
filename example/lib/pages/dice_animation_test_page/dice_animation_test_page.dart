import 'dart:math' as math;

import 'package:example/pages/dice_animation_test_page/cube_widget.dart';
import 'package:flutter/material.dart';

class DiceAnimationTestPage extends StatefulWidget {
  const DiceAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<DiceAnimationTestPage> createState() => _DiceAnimationTestPage();
}

class _DiceAnimationTestPage extends State<DiceAnimationTestPage> {
  double x = math.pi * 0.25;
  double y = math.pi * 0.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dice Animation Test Page'),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            setState(
              () {
                x = (x + (-details.delta.dy / 150)) % (math.pi * 2);
                y = (y + (-details.delta.dx / 150)) % (math.pi * 2);
              },
            );
          },
          child: Center(
            child: CubeWidget(
              x: x,
              y: y,
            ),
          ),
        ),
      ),
    );
  }
}
