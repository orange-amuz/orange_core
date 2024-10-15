import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trotter/trotter.dart';

class MovingSplitTestPage extends StatefulWidget {
  const MovingSplitTestPage({super.key});

  @override
  State<MovingSplitTestPage> createState() => _MovingSplitTestPageState();
}

class _MovingSplitTestPageState extends State<MovingSplitTestPage>
    with SingleTickerProviderStateMixin {
  final circles = <MovingCircleModel>[];

  static const minCircleRadius = 10;
  static const marginOfError = 1e-2;

  late final MovingCircleModel defaultCircle;
  late final double maxWidth;

  late final AnimationController animationController;

  final rnd = math.Random();

  bool isInit = false;

  void onTapUp(
    TapUpDetails details,
    MovingCircleModel tappedCircle,
    BoxConstraints constraints,
  ) async {
    final tappedLocalOffset = details.localPosition;

    final tappedOffset = Offset(
      tappedLocalOffset.dx + tappedCircle.center.dx - tappedCircle.radius,
      tappedLocalOffset.dy + tappedCircle.center.dy - tappedCircle.radius,
    );

    final removeIndex = circles.indexWhere(
      (element) => element.hashCode == tappedCircle.hashCode,
    );

    final bigCircle = _getBigCircle(
      tappedCircle,
      tappedOffset,
      constraints,
    );
    final smallCircle = _getSmallCircle(
      tappedCircle,
      tappedOffset,
      constraints,
    );

    final tempList = <MovingCircleModel>[];

    if (bigCircle.radius >= minCircleRadius) {
      tempList.add(bigCircle);
    }

    if (smallCircle.radius >= minCircleRadius) {
      tempList.add(smallCircle);
    }

    if (tempList.isNotEmpty) {
      await _addAllCircles(
        tappedCircle,
        tempList,
      );

      circles.addAll(tempList);

      if (removeIndex != -1) {
        circles.removeAt(removeIndex);
      }
    }
  }

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
          const Offset(0, 0),
        );
        defaultCircle.updateDirection(
          Offset(rnd.nextDouble() * 15, rnd.nextDouble() * 15),
        );

        circles.add(defaultCircle);

        animationController.repeat(reverse: true);

        isInit = true;

        updateScreen();
      },
    );

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
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
          if (isInit) {
            return Center(
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) {
                    if (circles.isEmpty) {
                      const SizedBox.shrink();
                    }

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
                ),
              ),
            );
          }

          return const SizedBox.shrink();
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
          onTapUp: (details) => onTapUp(details, circle, constraints),
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
    final collisionWithTop = positionY + delta.dy < 0;

    if (collisionWithRight) {
      circle.updatePosition(
        Offset(
          2 * mapMaxWidth - (positionX + delta.dx),
          positionY + delta.dy,
        ),
      );

      circle.updateDirection(
        Offset(
          -directionX,
          directionY,
        ),
      );
    } else if (collisionWithLeft) {
      circle.updatePosition(
        Offset(
          -(positionX + delta.dx),
          positionY + delta.dy,
        ),
      );

      circle.updateDirection(
        Offset(-directionX, directionY),
      );
    } else {
      circle.updatePosition(
        Offset(
          positionX + delta.dx,
          positionY + delta.dy,
        ),
      );
    }

    if (collisionWithBottom) {
      circle.updatePosition(
        Offset(
          positionX,
          2 * mapMaxHeight - (positionY + delta.dy),
        ),
      );

      circle.updateDirection(
        Offset(directionX, -directionY),
      );
    } else if (collisionWithTop) {
      circle.updatePosition(
        Offset(
          positionX,
          -positionY,
        ),
      );

      circle.updateDirection(
        Offset(directionX, -directionY),
      );
    }

    circle.updatePosition(
      Offset(circle.position.dx, circle.position.dy),
    );
  }

  MovingCircleModel _getBigCircle(
    MovingCircleModel tappedCircle,
    Offset tappedOffset,
    BoxConstraints constraints,
  ) {
    final distanceX = tappedOffset.dx - tappedCircle.center.dx;
    final distanceY = tappedOffset.dy - tappedCircle.center.dy;

    final distanceFromCenter = math.sqrt(
      math.pow(distanceX, 2) + math.pow(distanceY, 2),
    );

    final targetDiameter = distanceFromCenter + tappedCircle.radius;

    final ratio = targetDiameter / distanceFromCenter;

    final furthestOffset = Offset(
      tappedOffset.dx - distanceX * ratio,
      tappedOffset.dy - distanceY * ratio,
    );

    final result = MovingCircleModel(
      center: Offset(
        (tappedOffset.dx + furthestOffset.dx) / 2,
        (tappedOffset.dy + furthestOffset.dy) / 2,
      ),
      diameter: targetDiameter,
      velocity: tappedCircle.velocity,
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth - targetDiameter,
        maxHeight: constraints.maxHeight - targetDiameter,
      ),
    );

    result.updatePosition(
      Offset(
        tappedCircle.position.dx + tappedCircle.center.dx - result.center.dx,
        tappedCircle.position.dy + tappedCircle.center.dy - result.center.dy,
      ),
    );

    result.updateDirection(
      Offset(
        tappedCircle.direction.dx,
        tappedCircle.direction.dy,
      ),
    );

    return result;
  }

  MovingCircleModel _getSmallCircle(
    MovingCircleModel tappedCircle,
    Offset tappedOffset,
    BoxConstraints constraints,
  ) {
    final distanceX = tappedOffset.dx - tappedCircle.center.dx;
    final distanceY = tappedOffset.dy - tappedCircle.center.dy;

    final distanceFromCenter = math.sqrt(
      math.pow(distanceX, 2) + math.pow(distanceY, 2),
    );

    final targetDiameter = tappedCircle.radius - distanceFromCenter;

    final ratio = targetDiameter / distanceFromCenter;

    final furthestOffset = Offset(
      tappedOffset.dx + ratio * distanceX,
      tappedOffset.dy + ratio * distanceY,
    );

    final result = MovingCircleModel(
      center: Offset(
        (tappedOffset.dx + furthestOffset.dx) / 2,
        (tappedOffset.dy + furthestOffset.dy) / 2,
      ),
      diameter: targetDiameter,
      velocity: tappedCircle.velocity,
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth - targetDiameter,
        maxHeight: constraints.maxHeight - targetDiameter,
      ),
    );

    result.updatePosition(
      Offset(
        tappedCircle.position.dx + tappedCircle.center.dx - result.center.dx,
        tappedCircle.position.dy + tappedCircle.center.dy - result.center.dy,
      ),
    );

    result.updateDirection(
      Offset(
        tappedCircle.direction.dx,
        tappedCircle.direction.dy,
      ),
    );

    return result;
  }

  Future<void> _addAllCircles(
    MovingCircleModel tappedCircle,
    List<MovingCircleModel> splittedCircles,
  ) async {
    final permutationWith2 = Permutations(2, splittedCircles);

    for (final permutation in permutationWith2()) {
      final circumscriptions = getCircumscriptions(
        tappedCircle,
        permutation.elementAt(0),
        permutation.elementAt(1),
      );

      final tempList = <MovingCircleModel>[];
      final uniqueList = <MovingCircleModel>[];

      for (final circumscription in circumscriptions) {
        if (circumscription.radius < minCircleRadius) {
          continue;
        }

        final isInsideResult = isInside(tappedCircle, circumscription);

        if (!isInsideResult) {
          continue;
        }

        tempList.add(circumscription);
      }

      for (int i = 0; i < tempList.length; i++) {
        final temp = tempList.elementAt(i);

        final tempIndex = tempList.indexWhere(
          (element) => isUnique(element, temp),
          i + 1,
        );

        if (tempIndex != -1) {
          continue;
        }

        final circleIndex = splittedCircles.indexWhere(
          (element) => isUnique(element, temp),
        );

        if (circleIndex == -1) {
          temp.updatePosition(
            Offset(
              tappedCircle.position.dx +
                  tappedCircle.center.dx -
                  temp.center.dx,
              tappedCircle.position.dy +
                  tappedCircle.center.dy -
                  temp.center.dy,
            ),
          );

          temp.updateDirection(
            Offset(
              tappedCircle.direction.dx,
              tappedCircle.direction.dy,
            ),
          );

          uniqueList.add(temp);
        }
      }

      if (uniqueList.isNotEmpty) {
        splittedCircles.addAll(uniqueList);

        await _addAllCircles(tappedCircle, splittedCircles);
        return;
      }
    }
  }

  List<MovingCircleModel> getCircumscriptions(
    MovingCircleModel c1,
    MovingCircleModel c2,
    MovingCircleModel c3,
  ) {
    final curvatureC1 = -1 / c1.radius;
    final curvatureC2 = 1 / c2.radius;
    final curvatureC3 = 1 / c3.radius;

    final curvatureC12 = curvatureC1 * curvatureC2;
    final curvatureC23 = curvatureC2 * curvatureC3;
    final curvatureC31 = curvatureC3 * curvatureC1;

    final newCurvatureN = curvatureC1 +
        curvatureC2 +
        curvatureC3 -
        2 * math.sqrt((curvatureC12 + curvatureC23 + curvatureC31).abs());

    final newRadiusN = 1 / newCurvatureN;

    final newCurvatureP = curvatureC1 +
        curvatureC2 +
        curvatureC3 +
        2 * math.sqrt((curvatureC12 + curvatureC23 + curvatureC31).abs());

    final newRadiusP = 1 / newCurvatureP;

    final centersN = [
      ...getCenters(c2, c3, newRadiusN),
      ...getCenters(c3, c2, newRadiusN),
    ];

    final centersP = [
      ...getCenters(c2, c3, newRadiusP),
      ...getCenters(c3, c2, newRadiusP),
    ];

    return [
      ...List.generate(
        centersP.length,
        (index) => MovingCircleModel(
          center: centersP.elementAt(index),
          velocity: c1.velocity,
          constraints: c1.constraints,
          diameter: newRadiusP * 2,
        ),
      ),
      ...List.generate(
        centersN.length,
        (index) => MovingCircleModel(
          center: centersN.elementAt(index),
          velocity: c1.velocity,
          constraints: c1.constraints,
          diameter: newRadiusN * 2,
        ),
      ),
    ];
  }

  List<Offset> getCenters(
    MovingCircleModel c1,
    MovingCircleModel c2,
    double c3Radius,
  ) {
    final d12 = c1.radius + c2.radius;
    final d23 = c2.radius + c3Radius;
    final d31 = c3Radius + c1.radius;

    final x1 = c1.center.dx;
    final y1 = c1.center.dy;

    final x2 = c2.center.dx;
    final y2 = c2.center.dy;

    final ex = (x2 - x1) / d12;
    final ey = (y2 - y1) / d12;

    final x = (d31 * d31 - d23 * d23 + d12 * d12) / (2 * d12);
    final y = math.sqrt(d31 * d31 - x * x);

    final c3_1 = Offset(x1 + x * ex - y * ey, y1 + x * ey + y * ex);
    final c3_2 = Offset(x1 + x * ex + y * ey, y1 + x * ey - y * ex);

    return [c3_1, c3_2];
  }

  bool isInside(
    MovingCircleModel c1,
    MovingCircleModel c2,
  ) {
    final distanceX = c1.center.dx - c2.center.dx;
    final distanceY = c1.center.dy - c2.center.dy;

    final distance = math.sqrt(distanceY * distanceY + distanceX * distanceX);

    final result = c1.radius - c2.radius - distance;

    final isInside = marginOfError > result.abs();

    return isInside;
  }

  bool isUnique(
    MovingCircleModel element,
    MovingCircleModel target,
  ) {
    return (target.center.dx - element.center.dx).abs() < marginOfError &&
        (target.center.dy - element.center.dy).abs() < marginOfError;
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
    this.color = const Color.fromRGBO(0xff, 0xa0, 0x00, 0.3),
  });

  double get radius => diameter / 2;

  void dispose() {
    _position.close();

    _direction.close();
  }
}
