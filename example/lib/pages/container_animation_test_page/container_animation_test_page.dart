import 'package:animations/animations.dart';
import 'package:example/pages/container_animation_test_page/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ContainerAnimationTestPage extends StatefulWidget {
  const ContainerAnimationTestPage({super.key});

  @override
  State<ContainerAnimationTestPage> createState() =>
      _ContainerAnimationTestPageState();
}

class _ContainerAnimationTestPageState extends State<ContainerAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 500);
  static const animationCurve = Curves.easeInOut;

  late final fabAnimation = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  final widthTween = Tween<double>(begin: 25, end: 100)
      .chain(CurveTween(curve: animationCurve));
  final heightTween = Tween<double>(begin: 25, end: 200)
      .chain(CurveTween(curve: animationCurve));

  bool isOpend = false;

  @override
  void dispose() {
    fabAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
        // backgroundColor: Colors.black.withOpacity(0),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          OverflowBox(
            child: Lottie.asset(
              'assets/blur_bg.json',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
              reverse: true,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 56,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              child: Column(
                children: [
                  OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    useRootNavigator: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    closedElevation: 0,
                    openBuilder: (context, action) {
                      return const DetailPage();
                    },
                    closedBuilder: (context, action) {
                      return Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.yellow,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       OpenContainer(
      //         transitionType: ContainerTransitionType.fade,
      //         useRootNavigator: true,
      //         transitionDuration: const Duration(milliseconds: 500),
      //         closedShape: const RoundedRectangleBorder(
      //           borderRadius: BorderRadius.zero,
      //         ),
      //         closedElevation: 0,
      //         openBuilder: (context, action) {
      //           return const DetailPage();
      //         },
      //         closedBuilder: (context, action) {
      //           return Container(
      //             width: double.infinity,
      //             height: 100,
      //             color: Colors.yellow,
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      floatingActionButton: AnimatedBuilder(
        animation: fabAnimation,
        builder: (_, child) {
          final width = widthTween.transform(fabAnimation.value);
          final height = heightTween.transform(fabAnimation.value);

          return SizedBox(
            width: width,
            height: height,
            child: const Stack(
              children: [],
            ),
          );
        },
      ),
    );
  }
}
