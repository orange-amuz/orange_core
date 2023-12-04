import 'package:example/global_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateTestPage extends StatefulWidget {
  const StateTestPage({super.key});

  @override
  State<StateTestPage> createState() => _StateTestPageState();
}

class _StateTestPageState extends State<StateTestPage> {
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textEditingController.text = GlobalBloc.instance.currentTextSize.toString();
  }

  @override
  void dispose() {
    super.dispose();

    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: GlobalBloc.instance.textSize,
              builder: (_, textSizeSnapshot) {
                return TextField(
                  controller: textEditingController,
                  keyboardType: TextInputType.number,
                );
              },
            ),
            CupertinoButton(
              child: const Text('적용'),
              onPressed: () {
                FocusScope.of(context).unfocus();

                GlobalBloc.instance.updateTextSize(
                  double.parse(
                    textEditingController.text,
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
