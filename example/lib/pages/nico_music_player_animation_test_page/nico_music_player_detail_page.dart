import 'package:example/pages/nico_music_player_animation_test_page/nico_music_player_animation_test_page.dart';
import 'package:flutter/material.dart';

class NicoMusicPlayerDetailPage extends StatefulWidget {
  const NicoMusicPlayerDetailPage({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<NicoMusicPlayerDetailPage> createState() =>
      _NicoMusicPlayerDetailPageState();
}

class _NicoMusicPlayerDetailPageState extends State<NicoMusicPlayerDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: '${widget.index}',
              child: Container(
                width: 300,
                height: 300,
                color: colors.elementAt(widget.index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
