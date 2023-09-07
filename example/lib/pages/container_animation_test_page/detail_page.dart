import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
    );
    // return Dismissible(
    //   key: key,
    //   direction: DismissDirection.horizontal,
    //   resizeDuration: null,
    //   background: Container(
    //     color: Colors.transparent,
    //   ),
    //   onDismissed: (direction) {
    //     Navigator.pop(context);
    //   },
    //   child: Scaffold(
    //     appBar: AppBar(
    //       automaticallyImplyLeading: false,
    //       backgroundColor: Colors.black,
    //       leading: IconButton(
    //         icon: const Icon(
    //           Icons.arrow_back,
    //           color: Colors.white,
    //         ),
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
