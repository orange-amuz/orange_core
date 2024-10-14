import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class MovingSplitTestPage extends StatefulWidget {
  const MovingSplitTestPage({super.key});

  @override
  State<MovingSplitTestPage> createState() => _MovingSplitTestPageState();
}

class _MovingSplitTestPageState extends State<MovingSplitTestPage>
    with SingleTickerProviderStateMixin {
  final circles = <MovingCircleModel>[];

  late final MovingCircleModel defaultCircle;
  late final double maxWidth;

  late final AnimationController animationController;

  final rnd = math.Random();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timestamp) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        maxWidth = math.min(width, height) - 16;

        defaultCircle = MovingCircleModel(
          constraints: const BoxConstraints(),
          center: const Offset(0, 0),
          diameter: maxWidth,
          velocity: rnd.nextDouble() * 1.4 + 0.1,
        );

        defaultCircle.updatePosition(
          Offset.zero,
        );
        defaultCircle.updateDirection(
          Offset(rnd.nextDouble() * 15, rnd.nextDouble() * 15),
        );

        circles.add(defaultCircle);

        animationController.repeat(reverse: true);

        updateScreen();
      },
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    animationController.addListener(() {
      final firstCircle = circles.firstOrNull;

      if (firstCircle != null) {
        print(firstCircle.center);
        print(firstCircle.velocity);
        print(firstCircle.direction);
        print(firstCircle.position);
      }

      updateScreen();
    });
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();

    circles.clear();
  }

  void updateScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Moving Split Test Page'),
      ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          return AnimatedBuilder(
            animation: animationController,
            builder: (_, __) {
              return Stack(
                children: List.generate(
                  circles.length,
                  (index) => _buildCircle(
                    constraints,
                    circles.elementAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCircle(
    BoxConstraints constraints,
    MovingCircleModel circle,
  ) {
    _updateMovingCircleData(constraints: constraints, circle: circle);

    return Transform(
      alignment: Alignment.topLeft,
      transform: Matrix4.identity()
        ..translate(
          circle.position.dx,
          circle.position.dy,
        ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circle.diameter / 2),
        child: GestureDetector(
          child: Container(
            width: circle.diameter,
            height: circle.diameter,
            decoration: BoxDecoration(
              color: circle.color,
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  void _updateMovingCircleData({
    required BoxConstraints constraints,
    required MovingCircleModel circle,
  }) {
    circle.constraints = BoxConstraints(
      maxWidth: constraints.maxWidth - circle.diameter,
      maxHeight: constraints.maxHeight - circle.diameter,
    );

    final velocity = circle.velocity;

    final mapMaxWidth = circle.constraints.maxWidth;
    final mapMaxHeight = circle.constraints.maxHeight;

    final positionX = circle.position.dx;
    final positionY = circle.position.dy;

    final directionX = circle.direction.dx;
    final directionY = circle.direction.dy;

    final directionXSqure = math.pow(directionX, 2);
    final directionYSqure = math.pow(directionY, 2);

    final distance = math.sqrt(directionXSqure + directionYSqure);

    final delta = Offset(
      directionX / distance * velocity,
      directionY / distance * velocity,
    );

    final collisionWithRight = positionX + delta.dx > mapMaxWidth;
    final collisionWithLeft = positionX + delta.dx < 0;

    final collisionWithBottom = positionY + delta.dy > mapMaxHeight;
    final collisionWithTop = positionY + delta.dy < mapMaxHeight;

    if (collisionWithRight) {
      circle.updatePosition(
        Offset(2 * mapMaxWidth - (positionX + delta.dx), positionX + delta.dy),
      );

      circle.updateDirection(
        Offset(-directionX, directionY),
      );
    } else if (collisionWithLeft) {
      circle.updatePosition(
        Offset(-(positionX + delta.dx), positionY + delta.dy),
      );

      circle.updateDirection(
        Offset(-directionX, directionY),
      );
    } else {
      circle.updatePosition(
        Offset(positionX + delta.dx, positionY + delta.dy),
      );
    }

    if (collisionWithBottom) {
      circle.updatePosition(
        Offset(positionX, 2 * mapMaxHeight - (positionY + delta.dy)),
      );

      circle.updateDirection(
        Offset(directionX, -directionY),
      );
    } else if (collisionWithTop) {
      circle.updatePosition(
        Offset(positionX, -positionY),
      );

      circle.updateDirection(
        Offset(directionX, -directionY),
      );
    }

    circle.updatePosition(
      Offset(positionX, positionY),
    );
  }
}

class MovingCircleModel {
  final Offset center;
  final double diameter;

  final _position = ReplaySubject<Offset>(maxSize: 2);
  Stream<Offset> get positionStream => _position.stream;
  Offset get position => _position.values.last;
  void Function(Offset) get updatePosition => _position.sink.add;

  final _direction = ReplaySubject<Offset>(maxSize: 2);
  Offset get direction => _direction.values.last;
  void Function(Offset) get updateDirection => _direction.sink.add;

  BoxConstraints constraints;

  double velocity;

  Color color;

  MovingCircleModel({
    required this.center,
    required this.diameter,
    required this.velocity,
    required this.constraints,
    this.color = Colors.cyan,
  });

  double get radius => diameter / 2;

  void dispose() {
    _position.close();

    _direction.close();
  }
}
