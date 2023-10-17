import 'package:animations/animations.dart';
import 'package:example/pages/container_animation_test_page/custom_page_route.dart';
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

  final key = GlobalKey();

  @override
  void dispose() {
    fabAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          OverflowBox(
            child: Lottie.asset(
              'assets/blur_bg.json',
              width: size.width,
              height: size.height,
              fit:
                  size.width > size.height ? BoxFit.fitWidth : BoxFit.fitHeight,
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
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
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.blue,
                    // margin: const EdgeInsets.all(15),
                    child: GestureDetector(
                      key: key,
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(
                            key: key,
                            maintainState: false,
                            builder: (context) {
                              return const DetailPage();
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 14,
                          ),
                          Hero(
                            tag: 'title',
                            // flightShuttleBuilder: (
                            //   flightContext,
                            //   animation,
                            //   flightDirection,
                            //   fromHeroContext,
                            //   toHeroContext,
                            // ) {
                            //   final fromHeroWidget = fromHeroContext.widget;
                            //   final toHeroWidget = toHeroContext.widget;

                            //   return AnimatedBuilder(
                            //     animation: animation,
                            //     builder: (_, child) {
                            //       final width = Tween<double>(
                            //         begin: 80,
                            //         end: MediaQuery.of(context).size.width,
                            //       )
                            //           .chain(CurveTween(curve: Curves.linear))
                            //           .transform(animation.value);

                            //       print(width);

                            //       final height = math.min(
                            //         width,
                            //         MediaQuery.of(context).size.width / 2,
                            //       );

                            //       return UnconstrainedBox(
                            //         child: OverflowBox(
                            //           minWidth: width,
                            //           maxWidth: width,
                            //           maxHeight: height,
                            //           minHeight: height,
                            //           child: Container(
                            //             width: width,
                            //             height: height,
                            //             color: Colors.orange,
                            //             // child: OverflowBox(
                            //             //   child: toHeroWidget,
                            //             // ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   );
                            // },
                            // createRectTween: (begin, end) {
                            //   return Tween<Rect?>(
                            //     begin: Rect.fromLTRB(
                            //       begin?.left ?? 0,
                            //       begin?.top ?? 0,
                            //       begin?.right ?? 0,
                            //       begin?.bottom ?? 0,
                            //     ),
                            //     end: Rect.fromLTRB(
                            //       end?.left ?? 0,
                            //       end?.top ?? 0,
                            //       end?.right ?? 0,
                            //       end?.bottom ?? 0,
                            //     ),
                            //   );
                            // },
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
