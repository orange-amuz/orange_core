import 'dart:math' as math;

import 'package:example/pages/meta_ball_test_page/meta_ball.dart';
import 'package:flutter/material.dart';

class MetaBallTestPage extends StatefulWidget {
  const MetaBallTestPage({super.key});

  @override
  State<MetaBallTestPage> createState() => _MetaBallTestPageState();
}

class _MetaBallTestPageState extends State<MetaBallTestPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final rnd = math.Random();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            animationController.stop();
          },
          onTapUp: (details) {
            animationController.repeat();
          },
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Stack(
                children: List.generate(
                  500,
                  (index) {
                    return _buildBlob(
                      blobSize: rnd.nextInt(45).toDouble() + 5,
                      blobDirection: Offset(
                        rnd.nextInt(9).toDouble() + 1.6,
                        rnd.nextInt(9).toDouble() + 1.2,
                      ),
                      velocity: rnd.nextInt(2).toDouble() + 1,
                      color: Color.fromRGBO(
                        // rnd.nextInt(255),
                        255,
                        rnd.nextInt(255),
                        rnd.nextInt(255),
                        0.7,
                      ),
                    );
                  },
                )
                // ..add(
                //     BackdropFilter(
                //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                //       child: Container(),
                //     ),
                //   )
                ,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlob({
    double blobSize = 20,
    required Offset blobDirection,
    required double velocity,
    Color color = Colors.cyan,
  }) {
    return LayoutBuilder(
      builder: (_, constraints) {
        constraints = BoxConstraints(
          maxWidth: constraints.maxWidth - blobSize,
          maxHeight: constraints.maxHeight - blobSize,
        );

        Offset offset = Offset(
          constraints.maxWidth / 2,
          constraints.maxHeight / 2,
        );

        return AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            final distance = math.sqrt(
              math.pow(blobDirection.dx, 2) + math.pow(blobDirection.dy, 2),
            );

            Offset delta = Offset(
              blobDirection.dx / distance * velocity,
              blobDirection.dy / distance * velocity,
            );

            if ((offset.dx + delta.dx) > constraints.maxWidth) {
              offset = Offset(
                2 * constraints.maxWidth - (offset.dx + delta.dx),
                offset.dy + delta.dy,
              );

              blobDirection = Offset(-blobDirection.dx, blobDirection.dy);
            } else if (offset.dx + delta.dx < 0) {
              offset = Offset(
                -(offset.dx + delta.dx),
                offset.dy + delta.dy,
              );

              blobDirection = Offset(-blobDirection.dx, blobDirection.dy);
            } else {
              offset = Offset(
                offset.dx + delta.dx,
                offset.dy + delta.dy,
              );
            }

            if (offset.dy + delta.dy > constraints.maxHeight) {
              offset = Offset(
                offset.dx,
                2 * constraints.maxHeight - offset.dy,
              );

              blobDirection = Offset(blobDirection.dx, -blobDirection.dy);
            } else if (offset.dy + delta.dy < 0) {
              offset = Offset(
                offset.dx,
                -offset.dy,
              );

              blobDirection = Offset(blobDirection.dx, -blobDirection.dy);
            }

            return MetaBall(
              offset: offset,
              blobSize: blobSize,
              color: color,
            );
          },
        );
      },
    );
  }
}
