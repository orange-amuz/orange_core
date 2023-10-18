import 'dart:math' as math;

import 'package:example/pages/meta_ball_test_page/meta_ball.dart';
import 'package:example/pages/meta_ball_test_page/meta_ball_bloc.dart';
import 'package:flutter/material.dart';

class MetaBallTestPage extends StatefulWidget {
  const MetaBallTestPage({super.key});

  @override
  State<MetaBallTestPage> createState() => _MetaBallTestPageState();
}

class _MetaBallTestPageState extends State<MetaBallTestPage>
    with SingleTickerProviderStateMixin {
  static const int blobNumber = 100;

  late final AnimationController animationController;

  final bloc = MetaBallBloc();

  final rnd = math.Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < blobNumber; i++) {
      bloc.metaBallDataList.add(
        MetaBallData(
          constraints: const BoxConstraints(),
          size: rnd.nextInt(120) + 20,
          velocity: rnd.nextDouble() * 2 + 1,
          color: Color.fromRGBO(255, rnd.nextInt(255), rnd.nextInt(255), 0.75),
        )
          ..updateOffset(
            Offset.zero,
          )
          ..updateDirection(
            Offset(
              rnd.nextDouble() * 15,
              rnd.nextDouble() * 15,
            ),
          ),
      );
    }

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();

    bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              animationController.stop();
            },
            onTapUp: (details) {
              animationController.repeat();
            },
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) {
                    return Stack(
                      children: List.generate(
                        blobNumber,
                        (index) => _buildBlob(
                          constraints: constraints,
                          metaBallData: bloc.metaBallDataList.elementAt(index),
                        ),
                      )
                      // ..add(
                      //     BackdropFilter(
                      //       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      //       child: const SizedBox.shrink(),
                      //     ),
                      //   )
                      ,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlob({
    required BoxConstraints constraints,
    required MetaBallData metaBallData,
  }) {
    metaBallData.constraints = BoxConstraints(
      maxWidth: constraints.maxWidth - metaBallData.size,
      maxHeight: constraints.maxHeight - metaBallData.size,
    );

    final distance = math.sqrt(
      math.pow(metaBallData.direction.dx, 2) +
          math.pow(metaBallData.direction.dy, 2),
    );

    Offset delta = Offset(
      metaBallData.direction.dx / distance * metaBallData.velocity,
      metaBallData.direction.dy / distance * metaBallData.velocity,
    );

    if ((metaBallData.offset.dx + delta.dx) >
        metaBallData.constraints.maxWidth) {
      metaBallData.updateOffset(
        Offset(
          2 * metaBallData.constraints.maxWidth -
              (metaBallData.offset.dx + delta.dx),
          metaBallData.offset.dy + delta.dy,
        ),
      );

      metaBallData.updateDirection(
        Offset(
          -metaBallData.direction.dx,
          metaBallData.direction.dy,
        ),
      );
    } else if (metaBallData.offset.dx + delta.dx < 0) {
      metaBallData.updateOffset(
        Offset(
          -(metaBallData.offset.dx + delta.dx),
          metaBallData.offset.dy + delta.dy,
        ),
      );

      metaBallData.updateDirection(
        Offset(
          -metaBallData.direction.dx,
          metaBallData.direction.dy,
        ),
      );
    } else {
      metaBallData.updateOffset(
        Offset(
          metaBallData.offset.dx + delta.dx,
          metaBallData.offset.dy + delta.dy,
        ),
      );
    }

    if (metaBallData.offset.dy + delta.dy >
        metaBallData.constraints.maxHeight) {
      metaBallData.updateOffset(
        Offset(
          metaBallData.offset.dx,
          2 * metaBallData.constraints.maxHeight -
              (metaBallData.offset.dy + delta.dy),
        ),
      );

      metaBallData.updateDirection(
        Offset(
          metaBallData.direction.dx,
          -metaBallData.direction.dy,
        ),
      );
    } else if (metaBallData.offset.dy + delta.dy < 0) {
      metaBallData.updateOffset(
        Offset(
          metaBallData.offset.dx,
          -metaBallData.offset.dy,
        ),
      );

      metaBallData.updateDirection(
        Offset(
          metaBallData.direction.dx,
          -metaBallData.direction.dy,
        ),
      );
    }

    metaBallData.updateOffset(Offset(
      metaBallData.offset.dx,
      metaBallData.offset.dy,
    ));

    return MetaBall(
      offset: metaBallData.offset,
      blobSize: metaBallData.size,
      color: metaBallData.color,
    );
  }
}
