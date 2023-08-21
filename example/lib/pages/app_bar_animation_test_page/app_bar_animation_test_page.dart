import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class AppBarAnimationTestPage extends StatefulWidget {
  const AppBarAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<AppBarAnimationTestPage> createState() =>
      _AppBarAnimationTestPageState();
}

class _AppBarAnimationTestPageState extends State<AppBarAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const double minAppBarHeight = 56;
  static const double maxAppBarHeight = 200;

  static const double minPaddingSize = 15;
  static const double maxPaddingSize = 50;

  static const double minOpacityHeight = 100;

  final _scrollOffset = BehaviorSubject.seeded(0.0);
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        _scrollOffset.sink.add(
          scrollController.offset,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scrollOffset.close();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              controller: scrollController,
              padding: const EdgeInsets.only(
                top: maxAppBarHeight,
              ),
              children: List.generate(
                50,
                (index) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  ),
                  child: Text(
                    '$index',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: _scrollOffset.stream,
              builder: (_, scrollOffsetSnapshot) {
                final scrollOffset = scrollOffsetSnapshot.data ?? 0.0;

                final appBarHeight = math.max(
                  minAppBarHeight,
                  maxAppBarHeight - scrollOffset,
                );

                return Container(
                  width: double.infinity,
                  height: appBarHeight,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackButton(),
                      _buildAppBarTitle(
                        scrollOffset,
                        appBarHeight,
                      ),
                      _buildPlaceHolder(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: minAppBarHeight,
      height: minAppBarHeight,
      child: MaterialButton(
        child: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildAppBarTitle(
    double scrollOffset,
    double appBarHeight,
  ) {
    final appBarHeightRatio =
        ((appBarHeight - minAppBarHeight) / (maxAppBarHeight - minAppBarHeight))
            .clamp(0.0, 1.0);

    final double textSize = 15 + (5 * appBarHeightRatio);

    final paddingSize = math.min(
      maxPaddingSize,
      (appBarHeight * (maxPaddingSize - minPaddingSize)) /
          (maxAppBarHeight - minAppBarHeight),
    );

    final opacity = (appBarHeight.clamp(minOpacityHeight, maxAppBarHeight) -
            minOpacityHeight) /
        (maxAppBarHeight - minOpacityHeight);

    final isMin = (appBarHeight == minAppBarHeight);

    return Flexible(
      fit: FlexFit.tight,
      child: SizedBox(
        width: double.infinity,
        height: appBarHeight,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70,
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: opacity,
                  child: const Text(
                    'Hey',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              Text(
                '장주환님',
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: isMin ? FontWeight.normal : FontWeight.w900,
                  letterSpacing: 0,
                ),
                textScaleFactor: 1,
              ),
              SizedBox(
                width: double.infinity,
                height: paddingSize,
                child: Center(
                  child: Opacity(
                    opacity: opacity,
                    child: SizedBox(
                      height: 12 * 1.2,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'MY',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.2,
                              ),
                              textScaleFactor: 1,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12 * 1.2,
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceHolder() {
    return const SizedBox(
      width: minAppBarHeight,
      height: minAppBarHeight,
    );
  }
}
