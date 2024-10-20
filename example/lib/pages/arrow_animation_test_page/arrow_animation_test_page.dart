import 'package:flutter/material.dart';

class ArrowAnimationTestPage extends StatefulWidget {
  const ArrowAnimationTestPage({super.key});

  @override
  State<ArrowAnimationTestPage> createState() => _ArrowAnimationTestPageState();
}

class _ArrowAnimationTestPageState extends State<ArrowAnimationTestPage>
    with SingleTickerProviderStateMixin {
  static const double iconSize = 50;

  static const int durationValue = 1500;
  static const animationDuration = Duration(milliseconds: durationValue);
  static const animationCurve = Curves.linear;

  late final aniamtionController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  @override
  void initState() {
    super.initState();

    aniamtionController.repeat();
    // secondAnimationController.value = 1.0;

    // Future.delayed(Duration(milliseconds: (durationValue / 2).round())).then(
    //   (value) {
    //     if (mounted) {
    //       secondAnimationController.repeat();
    //     }
    //   },
    // );
  }

  @override
  void dispose() {
    aniamtionController.dispose();
    // secondAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Arrow Animation Test Page'),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 85,
            height: iconSize,
            color: Colors.yellow,
            child: LayoutBuilder(
              builder: (_, constraints) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildFirstAnimatedIcon(
                      aniamtionController,
                      constraints.maxWidth,
                    ),
                    _buildSecondAnimatedIcon(
                      aniamtionController,
                      constraints.maxWidth,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstAnimatedIcon(
    AnimationController controller,
    double maxWidth,
  ) {
    final posTween = Tween(
      begin: 0.0,
      end: maxWidth - iconSize,
    );

    final inOpacityTween = Tween(
      begin: 0.0,
      end: 1.0,
    );

    final outOpacityTween = Tween(
      begin: 1.0,
      end: 0.0,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final posValue = posTween
            .chain(CurveTween(curve: animationCurve))
            .transform(controller.value);

        late final double opacityValue;

        if (controller.value <= 0.5) {
          opacityValue =
              inOpacityTween.chain(CurveTween(curve: animationCurve)).transform(
                    controller.value * 2,
                  );
        } else {
          opacityValue = outOpacityTween
              .chain(CurveTween(curve: animationCurve))
              .transform(
                controller.value * 2 - 1,
              );
        }

        return Positioned(
          left: posValue,
          child: Opacity(
            opacity: opacityValue,
            child: _buildIcon(),
          ),
        );
      },
    );
  }

  Widget _buildSecondAnimatedIcon(
    AnimationController controller,
    double maxWidth,
  ) {
    final posTween = Tween(
      begin: 0.0,
      end: maxWidth - iconSize,
    );

    final inOpacityTween = Tween(
      begin: 0.0,
      end: 1.0,
    );

    final outOpacityTween = Tween(
      begin: 1.0,
      end: 0.0,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        late final double value;

        if (controller.value >= 0.5) {
          value = controller.value - 0.5;
        } else {
          value = controller.value + 0.5;
        }

        final posValue =
            posTween.chain(CurveTween(curve: animationCurve)).transform(value);

        late final double opacityValue;

        if (value <= 0.5) {
          opacityValue = inOpacityTween
              .chain(CurveTween(curve: animationCurve))
              .transform(value * 2);
        } else {
          opacityValue = outOpacityTween
              .chain(CurveTween(curve: animationCurve))
              .transform(value * 2 - 1);
        }

        return Positioned(
          left: posValue,
          child: Opacity(
            opacity: opacityValue,
            child: _buildIcon(),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    return const Icon(
      Icons.arrow_forward_ios_rounded,
      size: iconSize,
    );
  }
}
