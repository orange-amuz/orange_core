import 'dart:math' as math;

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final key = GlobalKey();

  final scrollController = ScrollController();

  late double imageHeight = MediaQuery.of(context).size.width / 2;
  BoxFit logoFit = BoxFit.fitHeight;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        scrollController.addListener(
          () {
            setState(
              () {
                imageHeight = math.max(
                  MediaQuery.of(context).size.width / 2 -
                      scrollController.offset,
                  0,
                );

                if (scrollController.offset > 0) {
                  logoFit = BoxFit.contain;
                } else {
                  logoFit = BoxFit.fitHeight;
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       // color: Colors.white,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         Icons.search,
      //         // color: Colors.white,
      //       ),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: LayoutBuilder(
        builder: (_, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  top: size.width / 2,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    ...List.generate(
                      50,
                      (index) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.brown,
                          child: Center(
                            child: Text('$index'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Hero(
                tag: 'title',
                child: Container(
                  width: size.width,
                  height: imageHeight,
                  color: Colors.cyan,
                  child: FittedBox(
                    fit: logoFit,
                    child: FlutterLogo(),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 56,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
