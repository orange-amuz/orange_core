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

  // static const transitionAnimationCurve = Curves.easeInOut;

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
                    transitionType: ContainerTransitionType.fadeThrough,
                    useRootNavigator: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    closedElevation: 0,
                    openBuilder: (context, action) {
                      return const DetailPage();

                      // return const Dialog(
                      //   insetPadding: EdgeInsets.zero,
                      //   child: DetailPage(),
                      // );
                      // return const SizedBox.shrink();
                    },
                    closedBuilder: (context, action) {
                      return Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.yellow,
                      );
                    },
                  ),
                  Hero(
                    tag: '${key.hashCode}',
                    transitionOnUserGestures: false,
                    child: Container(
                      key: key,
                      width: double.infinity,
                      height: 100,
                      color: Colors.blue,
                      child: GestureDetector(
                        onTap: () {
                          // final renderBox = key.currentContext
                          //     ?.findRenderObject() as RenderBox;

                          // final offset = renderBox.localToGlobal(Offset.zero);

                          Navigator.push(
                            context,
                            CustomPageRoute(
                              initialWidth: double.infinity,
                              initialHeight: 100,
                              maintainState: false,
                              builder: (context) {
                                return const DetailPage();
                              },
                            ),

                            // PageRouteBuilder(
                            //   fullscreenDialog: true,
                            //   barrierDismissible: true,
                            //   opaque: false,
                            //   pageBuilder: (
                            //     context,
                            //     animation,
                            //     secondaryAnimation,
                            //   ) {
                            //     return Hero(
                            //       // tag: '${key.hashCode}',
                            //       tag: '',
                            //       transitionOnUserGestures: false,
                            //       child: DetailPage(),
                            //     );
                            //   },
                            //   transitionsBuilder: (
                            //     context,
                            //     animation,
                            //     secondaryAnimation,
                            //     child,
                            //   ) {
                            //     final height = Tween<double>(
                            //       begin: 100,
                            //       end: MediaQuery.of(context).size.height,
                            //     )
                            //         .chain(CurveTween(
                            //             curve: transitionAnimationCurve))
                            //         .transform(
                            //           animation.value,
                            //         );

                            //     final topMargin = Tween<double>(
                            //       begin: offset.dy,
                            //       end: 0,
                            //     )
                            //         .chain(CurveTween(
                            //             curve: transitionAnimationCurve))
                            //         .transform(animation.value);

                            //     return SizedBox(
                            //       width: MediaQuery.of(context).size.width,
                            //       height: MediaQuery.of(context).size.height,
                            //       child: Container(
                            //         margin: EdgeInsets.only(
                            //           top: topMargin,
                            //         ),
                            //         alignment: Alignment.topCenter,
                            //         child: SizedBox(
                            //           height: height,
                            //           child: OverflowBox(
                            //             child: child,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            // MaterialPageRoute(
                            //   builder: (_) {
                            //     return DetailPage();
                            //   },
                            // ),
                          );
                        },
                      ),
                    ),
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
