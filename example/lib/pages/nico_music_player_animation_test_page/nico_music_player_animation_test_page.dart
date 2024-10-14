import 'dart:ui';

import 'package:example/pages/nico_music_player_animation_test_page/nico_music_player_detail_page.dart';
import 'package:flutter/material.dart';

const colors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
];

class NicoMusicPlayerAnimationTestPage extends StatefulWidget {
  const NicoMusicPlayerAnimationTestPage({super.key});

  @override
  State<NicoMusicPlayerAnimationTestPage> createState() =>
      _NicoMusicPlayerAnimationTestPageState();
}

class _NicoMusicPlayerAnimationTestPageState
    extends State<NicoMusicPlayerAnimationTestPage> {
  final pageController = PageController(
    viewportFraction: 0.8,
  );

  int currentPage = 0;

  ValueNotifier<double> scroll = ValueNotifier(0.0);

  void _onPageChanged(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  void _onTap(int index) {
    if (index == currentPage) {
      Navigator.push(
        context,
        PageRouteBuilder(
          fullscreenDialog: true,
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) =>
              NicoMusicPlayerDetailPage(
            index: index,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final opacityTween = Tween(begin: 0.0, end: 1.0);

            // final offsetTween = Tween(
            //   begin: const Offset(0.0, 1.0),
            //   end: const Offset(0.0, 0.0),
            // );

            // return SlideTransition(
            //   position: animation.drive(
            //     offsetTween,
            //   ),
            //   child: child,
            // );

            return FadeTransition(
              opacity: animation.drive(
                opacityTween,
              ),
              child: child,
              // child: Semantics(
              //   scopesRoute: true,
              //   explicitChildNodes: true,
              //   child: child,
              // ),
            );
          },
        ),
      );
      // showModalBottomSheet(
      //   context: context,
      //   elevation: 0,
      //   isScrollControlled: true,
      //   useSafeArea: true,
      //   builder: (context) {
      //     return NicoMusicPlayerDetailPage(
      //       index: index,
      //     );
      //     // return PageRouteBuilder(
      //     //   fullscreenDialog: false,
      //     //   barrierDismissible: true,
      //     //   pageBuilder: (context, animation, secondaryAnimation) =>
      //     //       NicoMusicPlayerDetailPage(
      //     //     index: index,
      //     //   ),
      //     //   transitionsBuilder:
      //     //       (context, animation, secondaryAnimation, child) {
      //     //     final opacityTween = Tween(begin: 0.0, end: 1.0);

      //     //     return FadeTransition(
      //     //       opacity: animation.drive(
      //     //         opacityTween,
      //     //       ),
      //     //       child: child,
      //     //     );
      //     //   },
      //     // );
      //   },
      // );
    } else {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    pageController.addListener(
      () {
        if (pageController.page == null) return;

        scroll.value = pageController.page!;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    pageController.dispose();

    scroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              key: ValueKey(currentPage),
              decoration: BoxDecoration(
                color: colors.elementAt(currentPage),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 15,
                  sigmaY: 15,
                ),
                child: Container(
                  color: Colors.black.withOpacity(
                    0.5,
                  ),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (_, constraints) {
                      return ValueListenableBuilder(
                        valueListenable: scroll,
                        builder: (_, scroll, child) {
                          final difference = (scroll - index).abs();

                          final scale = 1 - difference * 0.1;

                          return GestureDetector(
                            onTap: () {
                              _onTap(index);
                            },
                            child: Hero(
                              tag: '$index',
                              transitionOnUserGestures: true,
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: constraints.maxWidth,
                                  height: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                    color: colors.elementAt(index),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                        offset: const Offset(0, 8),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'title',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'subtitle',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
