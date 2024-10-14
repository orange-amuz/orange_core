import 'package:example/pages/split_test_page/split_test_bloc.dart';
import 'package:flutter/material.dart';

class SplitTestPage extends StatefulWidget {
  const SplitTestPage({super.key});

  @override
  State<SplitTestPage> createState() => _SplitTestPageState();
}

class _SplitTestPageState extends State<SplitTestPage> {
  final bloc = SplitTestBloc();

  @override
  void initState() {
    super.initState();

    bloc.initState(context);
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.flag,
        builder: (_, __) {
          if (bloc.isInit) {
            return Center(
              child: SizedBox(
                width: bloc.maxWidth,
                height: bloc.maxWidth,
                child: Stack(
                  children: [
                    _buildGuideCircles(),
                    _buildCircles(),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGuideCircles() {
    return Stack(
      children: List.generate(
        bloc.parentCircles.length,
        (circleIndex) {
          final circle = bloc.parentCircles.elementAt(
            circleIndex,
          );

          final top = bloc.getTopValue(circle);
          final left = bloc.getLeftValue(circle);

          return Positioned(
            top: top,
            left: left,
            child: Container(
              width: circle.diameter,
              height: circle.diameter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  circle.diameter,
                ),
                border: Border.all(
                  color: Colors.black.withOpacity(0.3),
                ),
                color: Colors.yellow.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircles() {
    return Stack(
      children: List.generate(
        bloc.circles.length,
        (circleIndex) {
          final circle = bloc.circles.elementAt(circleIndex);

          final parentOffset = Offset(
            bloc.getLeftValue(circle),
            bloc.getTopValue(circle),
          );

          return Positioned(
            left: parentOffset.dx,
            top: parentOffset.dy,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(circle.diameter),
              child: Container(
                width: circle.diameter,
                height: circle.diameter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    circle.diameter,
                  ),
                  border: Border.all(color: Colors.black),
                  color: Colors.red,
                ),
                child: GestureDetector(
                  onTapUp: (details) => bloc.onTapUp(
                    details,
                    parentOffset,
                    circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
