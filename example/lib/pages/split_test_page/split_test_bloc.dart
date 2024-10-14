import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:trotter/trotter.dart';

class SplitTestBloc {
  final parentCircles = <CircleModel>[];
  final circles = <CircleModel>[];

  static const double marginOfError = 1e-2;
  static const double minCircleRadius = 10;

  //----------------------------------------------------------------------------

  late final double maxWidth;
  late final CircleModel defaultCircle;

  //----------------------------------------------------------------------------

  bool isInit = false;

  //----------------------------------------------------------------------------

  final _flag = BehaviorSubject.seeded(false);
  Stream<bool> get flag => _flag.stream;
  void Function(bool) get updateFlag => _flag.sink.add;

  //----------------------------------------------------------------------------

  Future<void> onTapUp(
    TapUpDetails details,
    Offset parentOffset,
    CircleModel tappedCircle,
  ) async {
    final tappedLocalOffset = details.localPosition;

    final tappedOffset = Offset(
      tappedLocalOffset.dx + parentOffset.dx - defaultCircle.radius,
      tappedLocalOffset.dy + parentOffset.dy - defaultCircle.radius,
    );

    final removeIndex = circles.indexWhere(
      (element) => element.hashCode == tappedCircle.hashCode,
    );

    final bigCircle = _getBigCircle(tappedCircle, tappedOffset);
    final smallCircle = _getSmallCircle(tappedCircle, tappedOffset);

    final tempList = <CircleModel>[];

    if (bigCircle.radius >= minCircleRadius) {
      tempList.add(bigCircle);
    }

    if (smallCircle.radius >= minCircleRadius) {
      tempList.add(smallCircle);
    }

    if (tempList.isNotEmpty) {
      if (removeIndex != -1) {
        circles.removeAt(removeIndex);
      }

      circles.addAll(tempList);
      parentCircles.addAll(tempList);
    }

    _addAllCircles(tappedCircle);

    updateFlag(true);
  }

  CircleModel _getBigCircle(
    CircleModel tappedCircle,
    Offset tappedOffset,
  ) {
    final distanceX = tappedOffset.dx - tappedCircle.offset.dx;
    final distanceY = tappedOffset.dy - tappedCircle.offset.dy;

    final distanceFromCenter = math.sqrt(
      math.pow(distanceX, 2) + math.pow(distanceY, 2),
    );

    final targetDiameter = distanceFromCenter + tappedCircle.radius;

    final ratio = targetDiameter / distanceFromCenter;

    final furthestOffset = Offset(
      tappedOffset.dx - distanceX * ratio,
      tappedOffset.dy - distanceY * ratio,
    );

    final result = CircleModel(
      offset: Offset(
        (tappedOffset.dx + furthestOffset.dx) / 2,
        (tappedOffset.dy + furthestOffset.dy) / 2,
      ),
      diameter: targetDiameter,
    );

    return result;
  }

  CircleModel _getSmallCircle(
    CircleModel tappedCircle,
    Offset tappedOffset,
  ) {
    final distanceX = tappedOffset.dx - tappedCircle.offset.dx;
    final distanceY = tappedOffset.dy - tappedCircle.offset.dy;

    final distanceFromCenter = math.sqrt(
      math.pow(distanceX, 2) + math.pow(distanceY, 2),
    );

    final targetDiameter = tappedCircle.radius - distanceFromCenter;

    final ratio = targetDiameter / distanceFromCenter;

    final furthestOffset = Offset(
      tappedOffset.dx + ratio * distanceX,
      tappedOffset.dy + ratio * distanceY,
    );

    final result = CircleModel(
      offset: Offset(
        (tappedOffset.dx + furthestOffset.dx) / 2,
        (tappedOffset.dy + furthestOffset.dy) / 2,
      ),
      diameter: targetDiameter,
    );

    return result;
  }

  void _addAllCircles(
    CircleModel tappedCircle,
  ) {
    _addAllCircumscriptions(tappedCircle);

    // _addAllInscriptions();
  }

  void _addAllCircumscriptions(
    CircleModel tappedCircle,
  ) {
    final permutationWith2 = Permutations(2, circles);

    for (final permutation in permutationWith2()) {
      final circumScriptions = getCircumscriptions(
        tappedCircle,
        permutation.elementAt(0),
        permutation.elementAt(1),
      );

      final tempList = <CircleModel>[];

      for (final circumScription in circumScriptions) {
        if (circumScription.radius < minCircleRadius) {
          continue;
        }

        final isInsideResult = isInside(tappedCircle, circumScription);

        if (!isInsideResult) {
          continue;
        }

        tempList.add(circumScription);
      }

      final uniqueList = <CircleModel>[];

      for (int i = 0; i < tempList.length; i++) {
        final temp = tempList.elementAt(i);

        final tempIndex = tempList.indexWhere(
          (element) => isUnique(element, temp),
          i + 1,
        );

        if (tempIndex != -1) {
          continue;
        }

        final circlesIndex = circles.indexWhere(
          (element) => isUnique(element, temp),
        );

        if (circlesIndex == -1) {
          uniqueList.add(temp);
        }
      }

      if (uniqueList.isNotEmpty) {
        circles.addAll(uniqueList);
        parentCircles.addAll(uniqueList);

        _addAllCircumscriptions(tappedCircle);

        return;
      }
    }
  }

  // void _addAllInscriptions() {
  //   final permutationWith3 = Permutations(3, circles);

  //   for (final permutation in permutationWith3()) {
  //     final inscriptions = getInscriptions(
  //       permutation.elementAt(0),
  //       permutation.elementAt(1),
  //       permutation.elementAt(2),
  //     );

  //     final tempList = <CircleModel>[];

  //     for (final inscription in inscriptions) {
  //       if (inscription.radius < minCircleRadius) {
  //         continue;
  //       }

  //       final isInsideResult = isInside(defaultCircle, inscription);

  //       if (!isInsideResult) {
  //         continue;
  //       } else {
  //         dots.add(
  //           CircleModel(offset: inscription.offset, diameter: 3),
  //         );
  //       }

  //       tempList.add(inscription);
  //     }

  //     final uniqueList = <CircleModel>[];

  //     for (int i = 0; i < tempList.length; i++) {
  //       final temp = tempList.elementAt(i);

  //       final tempIndex = tempList.indexWhere(
  //         (element) => isUnique(element, temp),
  //         i + 1,
  //       );

  //       if (tempIndex != -1) {
  //         continue;
  //       }

  //       final circlesIndex = circles.indexWhere(
  //         (element) => isUnique(element, temp),
  //       );

  //       if (circlesIndex == -1) {
  //         uniqueList.add(temp);
  //       }
  //     }

  //     if (uniqueList.isNotEmpty) {
  //       circles.addAll(uniqueList);
  //       _addAllInscriptions();

  //       return;
  //     }
  //   }
  // }

  bool isUnique(
    CircleModel element,
    CircleModel target,
  ) {
    return (target.offset.dx - element.offset.dx).abs() < marginOfError &&
        (target.offset.dy - element.offset.dy).abs() < marginOfError;
  }

  List<CircleModel> getCircumscriptions(
    CircleModel c1,
    CircleModel c2,
    CircleModel c3,
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
        (index) => CircleModel(
          offset: centersP.elementAt(index),
          diameter: newRadiusP * 2,
        ),
      ),
      ...List.generate(
        centersN.length,
        (index) => CircleModel(
          offset: centersN.elementAt(index),
          diameter: newRadiusN * 2,
        ),
      ),
    ];
  }

  List<CircleModel> getInscriptions(
    CircleModel c1,
    CircleModel c2,
    CircleModel c3,
  ) {
    final curvatureC1 = 1 / c1.radius;
    final curvatureC2 = 1 / c2.radius;
    final curvatureC3 = 1 / c3.radius;

    final curvatureC12 = curvatureC1 * curvatureC2;
    final curvatureC23 = curvatureC2 * curvatureC3;
    final curvatureC31 = curvatureC3 * curvatureC1;

    final newCurvatureP = curvatureC3 +
        curvatureC2 +
        curvatureC1 +
        2 * math.sqrt(curvatureC12 + curvatureC23 + curvatureC31);

    final newCurvatureN = curvatureC3 +
        curvatureC2 +
        curvatureC1 -
        2 * math.sqrt(curvatureC12 + curvatureC23 + curvatureC31);

    final newRadiusP = (1 / newCurvatureP).abs();
    final newRadiusN = (1 / newCurvatureN).abs();

    final r1 = c1.radius;
    final r2 = c2.radius;
    final r3 = c3.radius;

    final x1 = c1.offset.dx;
    final y1 = c1.offset.dy;

    final x2 = c2.offset.dx;
    final y2 = c2.offset.dy;

    final x3 = c3.offset.dx;
    final y3 = c3.offset.dy;

    final const1 =
        (r2 * r2 - r1 * r1 + x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1) / 2;
    final const2 =
        (r3 * r3 - r1 * r1 + x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1) / 2;

    final y4 = (const2 - (const1 * (x3 - x1) / (x2 - x1))) /
        ((y3 - y1) - ((y2 - y1) * (x3 - x1) / (x2 - x1)));
    final x4 = (const1 - y4 * (y2 - y1)) / (x2 - x1);

    final offset = Offset(x4, y4);
    final newCircleP = CircleModel(offset: offset, diameter: newRadiusP * 2);
    final newCircleN = CircleModel(offset: offset, diameter: newRadiusN * 2);

    return [
      newCircleP,
      newCircleN,
    ];
  }

  List<Offset> getCenters(
    CircleModel c1,
    CircleModel c2,
    double c3Radius,
  ) {
    final d12 = c1.radius + c2.radius;
    final d23 = c2.radius + c3Radius;
    final d31 = c3Radius + c1.radius;

    final x1 = c1.offset.dx;
    final y1 = c1.offset.dy;

    final x2 = c2.offset.dx;
    final y2 = c2.offset.dy;

    final ex = (x2 - x1) / d12;
    final ey = (y2 - y1) / d12;

    final x = (d31 * d31 - d23 * d23 + d12 * d12) / (2 * d12);
    final y = math.sqrt(d31 * d31 - x * x);

    final c3_1 = Offset(x1 + x * ex - y * ey, y1 + x * ey + y * ex);
    final c3_2 = Offset(x1 + x * ex + y * ey, y1 + x * ey - y * ex);

    return [c3_1, c3_2];
  }

  bool isInside(
    CircleModel c1,
    CircleModel c2,
  ) {
    final distanceX = c1.offset.dx - c2.offset.dx;
    final distanceY = c1.offset.dy - c2.offset.dy;

    final distance = math.sqrt(distanceY * distanceY + distanceX * distanceX);

    final result = c1.radius - c2.radius - distance;

    final isInside = marginOfError > result.abs();

    return isInside;
  }

  bool hasCollision(
    CircleModel c1,
    CircleModel c2,
  ) {
    final distanceX = (c1.offset.dx - c2.offset.dx).abs();
    final distanceY = (c1.offset.dy - c2.offset.dy).abs();

    final distance = math.sqrt(math.pow(distanceY, 2) + math.pow(distanceX, 2));

    final result = (distance - (c1.radius + c2.radius)).abs();

    return result < 1;
  }

  //----------------------------------------------------------------------------

  double getTopValue(
    CircleModel circle,
  ) {
    return defaultCircle.radius + circle.offset.dy - circle.radius;
  }

  double getLeftValue(
    CircleModel circle,
  ) {
    return defaultCircle.radius + circle.offset.dx - circle.radius;
  }

  //----------------------------------------------------------------------------

  void initState(
    BuildContext context,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timestamp) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        maxWidth = math.min(width, height);

        defaultCircle = CircleModel(
          offset: const Offset(0, 0),
          diameter: maxWidth,
        );

        circles.add(defaultCircle);
        parentCircles.add(defaultCircle);

        isInit = true;
        updateFlag(true);
      },
    );
  }

  void dispose() {
    parentCircles.clear();
    circles.clear();

    _flag.close();
  }
}

class CircleModel {
  final Offset offset;
  final double diameter;

  CircleModel({
    required this.offset,
    required this.diameter,
  });

  double get radius => diameter / 2;
}
