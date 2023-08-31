import 'package:flutter/material.dart';

class FloatingActionButtonOpend extends StatefulWidget {
  const FloatingActionButtonOpend({super.key});

  @override
  State<FloatingActionButtonOpend> createState() =>
      _FloatingActionButtonOpendState();
}

class _FloatingActionButtonOpendState extends State<FloatingActionButtonOpend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (_, constraints) {
          return GestureDetector(
            onTapDown: (details) {
              Navigator.pop(context);
            },
            // child: Container(
            //   width: 25,
            //   height: 50,
            //   alignment: Alignment.bottomRight,
            //   child: Icon(Icons.abc),
            // ),
          );
        },
      ),
    );
  }
}
