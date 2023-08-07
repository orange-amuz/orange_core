import 'package:flutter/material.dart';

class CubeSide extends StatelessWidget {
  const CubeSide({
    Key? key,
    this.moveZ = true,
    this.xAngle = 0.0,
    this.yAngle = 0.0,
    this.zAngle = 0.0,
    this.shadow = 0.0,
    required this.num1,
    required this.num2,
  }) : super(key: key);

  final bool moveZ;

  final double xAngle;
  final double yAngle;
  final double zAngle;

  final double shadow;

  final int num1;
  final int num2;

  static const double diceSize = 150;
  static const Color diceColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(
          3,
          2,
          0.001,
        ),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..rotateX(xAngle)
          ..rotateY(yAngle)
          ..rotateZ(zAngle)
          ..translate(0.0, 0.0, moveZ ? -diceSize / 2 : diceSize / 2),
        child: Container(
          constraints: const BoxConstraints.expand(
            width: diceSize,
            height: diceSize,
          ),
          color: diceColor,
          foregroundDecoration: BoxDecoration(
            color: Colors.black.withOpacity(shadow.clamp(0.0, 1.0)),
            border: Border.all(
              width: 1,
              color: Colors.black26,
            ),
          ),
          child: Center(
            child: _buildDots(
              moveZ ? num1 : num2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDots(int dotNum) {
    if (dotNum == 2) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(2, (index) => _buildDot()),
        ),
      );
    } else if (dotNum == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => _buildDot()),
      );
    } else if (dotNum == 4) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (colIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (rowIndex) => _buildDot()),
            ),
          ),
        ),
      );
    } else if (dotNum == 5) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            3,
            (colIndex) {
              if (colIndex == 0 || colIndex == 2) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(2, (rowIndex) => _buildDot()),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(useMargin: false),
                ],
              );
            },
          ),
        ),
      );
    } else if (dotNum == 6) {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            2,
            (colIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (rowIndex) => _buildDot(useMargin: false),
              ),
            ),
          ),
        ),
      );
    }

    return _buildDot();
  }

  Widget _buildDot({
    bool useMargin = true,
  }) {
    return Container(
      width: 15,
      height: 15,
      margin: useMargin ? const EdgeInsets.all(15) : null,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(7.5),
      ),
    );
  }
}
