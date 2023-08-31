import 'dart:math' as math;
import 'package:example/pages/nico_music_player_animation_test_page/nico_music_player_animation_test_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class NicoMusicPlayerDetailPage extends StatefulWidget {
  const NicoMusicPlayerDetailPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<NicoMusicPlayerDetailPage> createState() =>
      _NicoMusicPlayerDetailPageState();
}

class _NicoMusicPlayerDetailPageState extends State<NicoMusicPlayerDetailPage>
    with TickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  bool isActivate = false;

  final key = GlobalKey();

  final _isPlaying = BehaviorSubject.seeded(false);
  final _soundValue = BehaviorSubject.seeded(0.0);

  late final soundController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  final scaleTween = Tween(begin: 1.0, end: 1.1);

  @override
  void dispose() {
    soundController.dispose();

    super.dispose();

    _isPlaying.close();
    _soundValue.close();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      direction: DismissDirection.down,
      resizeDuration: null,
      dismissThresholds: const {
        DismissDirection.down: 0.5,
      },
      onUpdate: (details) {
        if (details.reached && !isActivate) {
          isActivate = true;
          Navigator.pop(context);
        }
      },
      onDismissed: (direction) {
        // if (!isActivate) {
        //   Navigator.pop(context);
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: '${widget.index}',
                transitionOnUserGestures: true,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 8),
                      )
                    ],
                    color: colors.elementAt(widget.index),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'subtitle',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            StreamBuilder(
              stream: _isPlaying.stream,
              builder: (_, isPlayingSnapshot) {
                final isPlaying = isPlayingSnapshot.data ?? false;

                return IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 40,
                  ),
                  onPressed: () {
                    _isPlaying.sink.add(
                      !_isPlaying.value,
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 25,
            ),
            AnimatedBuilder(
              animation: soundController,
              builder: (_, child) {
                final scale = scaleTween
                    .chain(CurveTween(curve: animationCurve))
                    .transform(soundController.value);

                return LayoutBuilder(builder: (context, constraints) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanDown: (details) {
                          final soundValue = math.max(
                                details.localPosition.dx,
                                0,
                              ) /
                              constraints.maxWidth;

                          _soundValue.sink.add(soundValue);

                          soundController.forward();
                        },
                        onPanUpdate: (details) {
                          final soundValue = math.max(
                                details.localPosition.dx,
                                0,
                              ) /
                              constraints.maxWidth;

                          _soundValue.sink.add(soundValue);
                        },
                        onPanEnd: (details) {
                          soundController.reverse();
                        },
                        onPanCancel: () {
                          soundController.reverse();
                        },
                        child: StreamBuilder(
                          stream: _soundValue.stream,
                          builder: (_, soundValueSnapshot) {
                            final soundValue = soundValueSnapshot.data ?? 0.0;

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                width: constraints.maxWidth,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: constraints.maxWidth * soundValue,
                                  height: constraints.maxHeight,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
