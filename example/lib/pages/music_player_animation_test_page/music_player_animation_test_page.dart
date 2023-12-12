import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum MusicPlayerState {
  expanded,
  changing,
  contracted,
}

class MusicPlayerAnimationTestPage extends StatefulWidget {
  const MusicPlayerAnimationTestPage({Key? key}) : super(key: key);

  @override
  State<MusicPlayerAnimationTestPage> createState() =>
      _MusicPlayerAnimationTestPageState();
}

class _MusicPlayerAnimationTestPageState
    extends State<MusicPlayerAnimationTestPage> with TickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 300);
  static const animationCurve = Curves.easeInOut;

  static const double minPlayerHeight = 70;
  late final double maxPlayerHeight = MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.bottom;

  late final double togglePlayerHeight =
      MediaQuery.of(context).size.height * 3 / 4;

  static const double minAlbumImageSize = 55;
  late final double maxAlbumImageSize =
      MediaQuery.of(context).size.width - 34 - maxAlbumPaddingSize * 2;

  static const double maxAlbumPaddingSize = 40;

  late final double minBottomSheetHeight =
      60 + MediaQuery.of(context).padding.bottom;
  late final double maxBottomSheetHeight = MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.vertical -
      minPlayerHeight +
      MediaQuery.of(context).padding.bottom;

  final String title = 'Here is 노래 제목';
  final String artist = 'Here is 가수 이름';

  final _playerHeight = BehaviorSubject.seeded(minPlayerHeight);

  final _backgroundOpacity = BehaviorSubject.seeded(0.0);

  final _appearOpacity = BehaviorSubject.seeded(1.0);

  final _topPadding = BehaviorSubject.seeded(7.5);

  final _albumSize = BehaviorSubject.seeded(minAlbumImageSize);

  final _albumPadding = BehaviorSubject.seeded(0.0);

  final _bottomSheetHeight = BehaviorSubject.seeded(0.0);

  late final musicPlayerAnimationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );
  late final bottomSheetAnimationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  MusicPlayerState musicPlayerState = MusicPlayerState.contracted;

  final _isPlaying = BehaviorSubject.seeded(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    musicPlayerAnimationController.dispose();

    bottomSheetAnimationController.dispose();

    super.dispose();

    _playerHeight.close();

    _backgroundOpacity.close();

    _appearOpacity.close();

    _topPadding.close();

    _albumSize.close();

    _albumPadding.close();

    _bottomSheetHeight.close();

    _isPlaying.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder(
              stream: _playerHeight.stream,
              builder: (_, playerHeightSnapshot) {
                final height = playerHeightSnapshot.data ?? minPlayerHeight;

                final dismissOpacity =
                    (height / minPlayerHeight).clamp(0.0, 1.0);

                return Opacity(
                  opacity: dismissOpacity,
                  child: Container(
                    width: double.infinity,
                    height: height + MediaQuery.of(context).padding.bottom,
                    color: Colors.black.withOpacity(0.85),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        musicPlayerAnimateToMax(height);
                      },
                      onPanStart: (details) {},
                      onPanUpdate: (details) {
                        final dy = details.delta.dy;

                        if (dy != 0) {
                          final targetHeight = _playerHeight.value - dy;

                          if (musicPlayerState == MusicPlayerState.expanded) {
                            final bottomSheetHeight =
                                _bottomSheetHeight.value - dy;

                            if (bottomSheetHeight < minBottomSheetHeight) {
                              musicPlayerState = MusicPlayerState.changing;
                            } else {}

                            updateBottomSheetHeight(bottomSheetHeight);
                          } else {
                            updateMusicPlayerHeight(targetHeight);
                          }
                        }
                      },
                      onPanEnd: (details) {
                        final speed = details.velocity.pixelsPerSecond.dy;

                        if (dismissOpacity < 0.4) {
                        } else {
                          if (musicPlayerState == MusicPlayerState.expanded) {
                            final bottomSheetHeight = _bottomSheetHeight.value;

                            if (speed < 0) {
                              bottomSheetAnimateToMax(bottomSheetHeight);
                            } else if (speed == 0) {
                              if (bottomSheetHeight <
                                  maxBottomSheetHeight / 2) {
                                bottomSheetAnimateToMin(
                                  bottomSheetHeight,
                                );
                              } else {
                                bottomSheetAnimateToMax(
                                  bottomSheetHeight,
                                );
                              }
                            } else {
                              bottomSheetAnimateToMin(bottomSheetHeight);
                            }
                          } else {
                            if (speed < 0) {
                              musicPlayerAnimateToMax(height);
                            } else if (speed == 0) {
                              if (height < maxPlayerHeight / 2) {
                                musicPlayerAnimateToMin(height);
                              } else {
                                musicPlayerAnimateToMax(height);
                              }
                            } else {
                              musicPlayerAnimateToMin(height);
                            }
                          }
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            StreamBuilder(
                              stream: _bottomSheetHeight.stream,
                              builder: (_, bottomSheetHeightSnapshot) {
                                final bottomSheetHeight =
                                    bottomSheetHeightSnapshot.data ?? 0.0;

                                final targetHeight = ((bottomSheetHeight -
                                                minBottomSheetHeight) /
                                            (maxBottomSheetHeight -
                                                minBottomSheetHeight))
                                        .clamp(0.0, 1.0) *
                                    MediaQuery.of(context).padding.top;

                                return SizedBox(
                                  height: targetHeight,
                                );
                              },
                            ),
                            StreamBuilder(
                              stream: _topPadding.stream,
                              builder: (_, paddingTopSnapshot) {
                                final paddingTop =
                                    paddingTopSnapshot.data ?? 7.5;

                                return SizedBox(
                                  width: double.infinity,
                                  height: paddingTop,
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top,
                                    ),
                                    child: StreamBuilder(
                                      stream: _backgroundOpacity.stream,
                                      builder: (_, backgroundOpacitySnapshot) {
                                        final backgroundOpacity =
                                            backgroundOpacitySnapshot.data ??
                                                0.0;

                                        return Opacity(
                                          opacity: backgroundOpacity,
                                          child: _buildPlayerAppBarArea(
                                            onPressedAnimateToMin: () {
                                              musicPlayerAnimateToMin(height);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                  stream: _albumSize.stream,
                                  builder: (_, albumSizeSnapshot) {
                                    return StreamBuilder(
                                      stream: _albumPadding.stream,
                                      builder: (_, albumPaddingSnapshot) {
                                        final albumImageSize =
                                            albumSizeSnapshot.data ??
                                                minAlbumImageSize;

                                        final albumImagePadding =
                                            albumPaddingSnapshot.data ?? 0;

                                        return Container(
                                          width: albumImageSize,
                                          height: albumImageSize,
                                          margin: EdgeInsets.only(
                                            left: 17 + albumImagePadding,
                                            right: 17 + albumImagePadding,
                                          ),
                                          child: const Placeholder(),
                                        );
                                      },
                                    );
                                  },
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: StreamBuilder(
                                    stream: _appearOpacity.stream,
                                    builder: (_, appearOpacitySnapshot) {
                                      final appearOpacity =
                                          appearOpacitySnapshot.data ?? 1.0;

                                      return Opacity(
                                        opacity: appearOpacity,
                                        child: _buildMiniPlayerArea(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: _backgroundOpacity.stream,
                              builder: (_, backgroundOpacitySnapshot) {
                                final backgroundOpacity =
                                    backgroundOpacitySnapshot.data ?? 0.0;

                                return Opacity(
                                  opacity: backgroundOpacity,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: maxAlbumPaddingSize - 10,
                                      right: maxAlbumPaddingSize - 10,
                                    ),
                                    child: _buildPlayerControllerArea(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: StreamBuilder(
              stream: _bottomSheetHeight.stream,
              builder: (_, bottomSheetSnapshot) {
                final height = bottomSheetSnapshot.data ?? 0;

                final opacity = (height / minBottomSheetHeight).clamp(
                  0.0,
                  1.0,
                );

                return Opacity(
                  opacity: opacity,
                  child: Container(
                    width: double.infinity,
                    height: height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      color: Color.fromRGBO(70, 70, 70, 1),
                    ),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final dy = details.delta.dy;

                        if (dy != 0) {
                          final targetHeight = _bottomSheetHeight.value - dy;

                          updateBottomSheetHeight(targetHeight);
                        }
                      },
                      onPanEnd: (details) {
                        final speed = details.velocity.pixelsPerSecond.dy;

                        if (speed < 0) {
                          bottomSheetAnimateToMax(height);
                        } else if (speed == 0) {
                          if (height < maxBottomSheetHeight / 2) {
                            bottomSheetAnimateToMin(height);
                          } else {
                            bottomSheetAnimateToMax(height);
                          }
                        } else {
                          bottomSheetAnimateToMin(height);
                        }
                      },
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              width: 30,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              margin: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: MaterialButton(
                                    child: const Text(
                                      '다음 트랙',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: MaterialButton(
                                    child: const Text(
                                      '가사',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: MaterialButton(
                                    child: const Text(
                                      '관련 항목',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerAppBarArea({
    Function()? onPressedAnimateToMin,
  }) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.expand_more,
            color: Colors.white,
          ),
          onPressed: onPressedAnimateToMin,
        ),
        const IconButton(
          icon: SizedBox.shrink(),
          onPressed: null,
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' 노래 ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  ' 동영상 ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.cast,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMiniPlayerArea() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            height: minAlbumImageSize,
            width: 175,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: StreamBuilder(
                  stream: _isPlaying.stream,
                  builder: (_, isPlayingSnapshot) {
                    final isPlaying = isPlayingSnapshot.data ?? false;

                    if (isPlaying) {
                      return const Icon(
                        Icons.pause,
                        size: 28,
                        color: Colors.white,
                      );
                    } else {
                      return const Icon(
                        Icons.play_arrow,
                        size: 28,
                        color: Colors.white,
                      );
                    }
                  },
                ),
                onPressed: () {
                  _isPlaying.sink.add(!_isPlaying.value);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  size: 28,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const SizedBox(
                width: 17,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControllerArea() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 25,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.thumb_down_outlined,
                ),
                onPressed: () {},
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      artist,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.thumb_up_outlined,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          width: double.infinity,
          height: 10,
          padding: const EdgeInsets.only(
            left: 14,
            right: 14,
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.white.withOpacity(0.7),
                margin: const EdgeInsets.only(
                  top: 4.5,
                  bottom: 4.5,
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 5,
            left: 14,
            right: 14,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0:00',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
              Text(
                '4:03',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(
            top: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shuffle,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: StreamBuilder(
                  stream: _isPlaying.stream,
                  builder: (_, isPlayingSnapshot) {
                    final isPlaying = isPlayingSnapshot.data ?? false;

                    if (isPlaying) {
                      return const Icon(
                        Icons.pause,
                        size: 40,
                        color: Colors.white,
                      );
                    } else {
                      return const Icon(
                        Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      );
                    }
                  },
                ),
                onPressed: () {
                  _isPlaying.sink.add(!_isPlaying.value);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.repeat,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------

  void updateValue(
    double targetHeight,
  ) {
    final playerHeightRatio = (targetHeight - togglePlayerHeight) /
        (maxPlayerHeight - togglePlayerHeight);

    _backgroundOpacity.sink.add(
      playerHeightRatio.clamp(0.0, 1.0),
    );

    final currentPlayerHeightRatio = (targetHeight - minPlayerHeight) /
        (togglePlayerHeight - minPlayerHeight);

    _appearOpacity.sink.add(
      (1 - currentPlayerHeightRatio).clamp(0.0, 1.0),
    );

    _topPadding.sink.add(
      math.max(
        currentPlayerHeightRatio *
                (56 + 10 + 10 + MediaQuery.of(context).padding.top) +
            7.5,
        7.5,
      ),
    );

    _albumSize.sink.add(
      (currentPlayerHeightRatio * (maxAlbumImageSize - minAlbumImageSize) +
              minAlbumImageSize)
          .clamp(
        minAlbumImageSize,
        maxAlbumImageSize,
      ),
    );

    _albumPadding.sink.add(
      (currentPlayerHeightRatio * maxAlbumPaddingSize).clamp(
        0.0,
        maxAlbumPaddingSize,
      ),
    );
  }

  //----------------------------------------------------------------------------

  void musicPlayerAnimateToMax(
    double height,
  ) {
    if (_bottomSheetHeight.value <= minBottomSheetHeight) {
      final animation = Tween(begin: height, end: maxPlayerHeight)
          .chain(CurveTween(curve: animationCurve))
          .animate(musicPlayerAnimationController);

      animation.addListener(() {
        _playerHeight.sink.add(animation.value);
        _bottomSheetHeight.sink.add(
          (animation.value - minPlayerHeight) /
              (maxPlayerHeight - minPlayerHeight) *
              minBottomSheetHeight,
        );

        updateValue(animation.value);
      });

      musicPlayerAnimationController.reset();
      musicPlayerAnimationController.forward().then(
        (value) {
          animation.removeListener(
            () {
              _playerHeight.sink.add(animation.value);
              _bottomSheetHeight.sink.add(
                (animation.value - minPlayerHeight) /
                    (maxPlayerHeight - minPlayerHeight) *
                    minBottomSheetHeight,
              );

              updateValue(animation.value);
            },
          );

          musicPlayerState = MusicPlayerState.expanded;
        },
      );
    } else {}
  }

  void musicPlayerAnimateToMin(
    double height,
  ) {
    if (_bottomSheetHeight.value <= minBottomSheetHeight) {
      final animation = Tween(begin: height, end: minPlayerHeight)
          .chain(CurveTween(curve: animationCurve))
          .animate(musicPlayerAnimationController);

      animation.addListener(() {
        _playerHeight.sink.add(animation.value);
        _bottomSheetHeight.sink.add(
          (animation.value - minPlayerHeight) /
              (maxPlayerHeight - minPlayerHeight) *
              minBottomSheetHeight,
        );

        updateValue(animation.value);
      });

      musicPlayerAnimationController.reset();
      musicPlayerAnimationController.forward().then(
        (value) {
          animation.removeListener(
            () {
              _playerHeight.sink.add(animation.value);
              _bottomSheetHeight.sink.add(
                (animation.value - minPlayerHeight) /
                    (maxPlayerHeight - minPlayerHeight) *
                    minBottomSheetHeight,
              );

              updateValue(animation.value);
            },
          );

          musicPlayerState = MusicPlayerState.contracted;
        },
      );
    } else {}
  }

  void updateMusicPlayerHeight(double targetHeight) {
    if (targetHeight > maxPlayerHeight) {
      _playerHeight.sink.add(maxPlayerHeight);
      _bottomSheetHeight.sink.add(minBottomSheetHeight);

      musicPlayerState = MusicPlayerState.expanded;
    } else {
      _playerHeight.sink.add(targetHeight);

      if (targetHeight >= 0) {
        _bottomSheetHeight.sink.add(
          math.max(
              (targetHeight - minPlayerHeight) /
                  (maxPlayerHeight - minPlayerHeight) *
                  minBottomSheetHeight,
              0.0),
        );
        updateValue(targetHeight);
      }

      if (targetHeight <= minPlayerHeight) {
        musicPlayerState = MusicPlayerState.contracted;
      } else {
        musicPlayerState = MusicPlayerState.changing;
      }
    }
  }

  //----------------------------------------------------------------------------

  void bottomSheetAnimateToMax(
    double height,
  ) {
    final animation = Tween(begin: height, end: maxBottomSheetHeight)
        .chain(CurveTween(curve: animationCurve))
        .animate(bottomSheetAnimationController);

    animation.addListener(() {
      _bottomSheetHeight.sink.add(
        animation.value,
      );

      updateValue(
        (1 -
                    ((animation.value - minBottomSheetHeight) /
                        (maxBottomSheetHeight - minBottomSheetHeight))) *
                (maxPlayerHeight - minPlayerHeight) +
            minPlayerHeight,
      );
    });

    bottomSheetAnimationController.reset();
    bottomSheetAnimationController.forward().then(
      (value) {
        animation.removeListener(
          () {
            _bottomSheetHeight.sink.add(
              animation.value,
            );

            updateValue(
              (1 -
                          ((animation.value - minBottomSheetHeight) /
                              (maxBottomSheetHeight - minBottomSheetHeight))) *
                      (maxPlayerHeight - minPlayerHeight) +
                  minPlayerHeight,
            );
          },
        );
      },
    );
  }

  void bottomSheetAnimateToMin(
    double height,
  ) {
    final animation = Tween(begin: height, end: minBottomSheetHeight)
        .chain(CurveTween(curve: animationCurve))
        .animate(bottomSheetAnimationController);

    animation.addListener(() {
      _bottomSheetHeight.sink.add(
        animation.value,
      );

      updateValue(
        (1 -
                    ((animation.value - minBottomSheetHeight) /
                        (maxBottomSheetHeight - minBottomSheetHeight))) *
                (maxPlayerHeight - minPlayerHeight) +
            minPlayerHeight,
      );
    });

    bottomSheetAnimationController.reset();
    bottomSheetAnimationController.forward().then(
      (value) {
        animation.removeListener(
          () {
            _bottomSheetHeight.sink.add(
              animation.value,
            );

            updateValue(
              (1 -
                          ((animation.value - minBottomSheetHeight) /
                              (maxBottomSheetHeight - minBottomSheetHeight))) *
                      (maxPlayerHeight - minPlayerHeight) +
                  minPlayerHeight,
            );
          },
        );
      },
    );
  }

  void updateBottomSheetHeight(double targetHeight) {
    if (targetHeight >= maxBottomSheetHeight) {
      _bottomSheetHeight.sink.add(maxBottomSheetHeight);
    } else if (targetHeight <= minBottomSheetHeight) {
      _bottomSheetHeight.sink.add(minBottomSheetHeight);
    } else {
      _bottomSheetHeight.sink.add(targetHeight);

      updateValue(
        (1 -
                        ((targetHeight - minBottomSheetHeight) /
                            (maxBottomSheetHeight - minBottomSheetHeight)))
                    .clamp(
                  0.0,
                  1.0,
                ) *
                (maxPlayerHeight - minPlayerHeight) +
            minPlayerHeight,
      );
    }
  }
}
