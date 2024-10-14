import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationTestPage extends StatefulWidget {
  const LottieAnimationTestPage({super.key});

  @override
  State<LottieAnimationTestPage> createState() =>
      _LottieAnimationTestPageState();
}

class _LottieAnimationTestPageState extends State<LottieAnimationTestPage>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     controller.forward();
    //   },
    // );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lottie Animation Test Page'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              child: Lottie.network(
                'https://raw.githubusercontent.com/juhwan976/BAEMIN/master/baemin_app/assets/MyBaemin/bronze/data.json',
                controller: controller,
                repeat: false,
                onLoaded: (p0) => controller.forward(),
              ),
              onTap: () {
                controller.reset();
                controller.forward();
              },
            ),
          ],
        ),
      ),
    );
  }
}
