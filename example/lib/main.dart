import 'package:example/pages/app_bar_animation_test_page/app_bar_animation_test_page.dart';
import 'package:example/pages/apple_watch_animation_test_page/apple_watch_animation_test_page.dart';
import 'package:example/pages/arrow_animation_test_page/arrow_animation_test_page.dart';
import 'package:example/pages/card_animation_test_page/card_animation_test_page.dart';
import 'package:example/pages/container_animation_test_page/container_animation_test_page.dart';
import 'package:example/pages/dice_animation_test_page/dice_animation_test_page.dart';
import 'package:example/pages/hover_animation_test_page/hover_animation_test_page.dart';
import 'package:example/pages/music_player_animation_test_page/music_player_animation_test_page.dart';
import 'package:example/pages/nico_music_player_animation_test_page/nico_music_player_animation_test_page.dart';
import 'package:example/pages/square_animation_test_page/square_animation_test_page.dart';
import 'package:example/pages/swing_animation_test_page/swing_animation_test_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_core/orange_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        if (!ScreenUtil.isInitialize()) {
          ScreenUtil.initialize(
            context,
            designedHeight: 375,
            designedWidth: 767,
          );
        } else {
          ScreenUtil.updateScreenValues(context);
        }

        return child!;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final lottieController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();

    lottieController.repeat();
  }

  @override
  void dispose() {
    lottieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScaleButton(),
              const Divider(),
              _buildListButton(),
              const Divider(),
              _buildTestPages(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScaleButton() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          child: const Text('Scale Button'),
        ),
        OrangeScaleButton(
          margin: EdgeInsets.only(
            left: ScreenUtil.getWidth(14),
            right: ScreenUtil.getWidth(14),
          ),
          child: Container(
            width: double.infinity,
            height: 50,
            color: Theme.of(context).colorScheme.inversePrimary,
            child: const Center(
              child: Text('Push Me!'),
            ),
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildListButton() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          child: const Text('List Button'),
        ),
        OrangeListButton(
          padding: const EdgeInsets.only(
            left: 14,
            right: 14,
          ),
          child: const SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text('Push Me!'),
            ),
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildTestPages() {
    return Column(
      children: [
        CupertinoButton(
          child: const Text(
            'Go To Hover Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HoverAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Card Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CardAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Dice Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DiceAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To AppBar Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AppBarAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Apple Watch Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AppleWatchAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Music Player Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MusicPlayerAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Swing Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SwingAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Square Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SquareAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Nico Music Player Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NicoMusicPlayerAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Arrow Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ArrowAnimationTestPage(),
              ),
            );
          },
        ),
        CupertinoButton(
          child: const Text(
            'Go To Container Animation Page',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ContainerAnimationTestPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
