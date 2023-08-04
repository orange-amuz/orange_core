import 'package:example/pages/animation_test_page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // print(ScreenUtil.appHeight);
    // print(ScreenUtil.appWidth);
    // print(ScreenUtil.maxWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              child: const Text('scale button'),
            ),
            OrangeScaleButton(
              margin: EdgeInsets.only(
                left: ScreenUtil.getWidth(14),
                right: ScreenUtil.getWidth(14),
              ),
              child: Container(
                width: double.infinity,
                height: 50,
                color: Colors.green,
                child: const Center(
                  child: Text('push me!'),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnimationTestPage(),
                  ),
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                bottom: 10,
              ),
              child: const Text('list button'),
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
                  child: Text('push me!'),
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
