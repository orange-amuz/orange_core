import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class MetaBallBloc {
  final metaBallDataList = List<MetaBallData>.empty(growable: true);

  //----------------------------------------------------------------------------

  void dispose() {
    for (MetaBallData metaBallData in metaBallDataList) {
      metaBallData.dispose();
    }

    metaBallDataList.clear();
  }
}

class MetaBallData {
  BoxConstraints constraints;

  double size;

  final _offset = ReplaySubject<Offset>(maxSize: 2);

  Offset get offset => _offset.values.last;

  Function(Offset) get updateOffset => _offset.sink.add;

  final _direction = ReplaySubject<Offset>(maxSize: 2);

  Offset get direction => _direction.values.last;

  Function(Offset) get updateDirection => _direction.sink.add;

  double velocity;

  Color color;

  MetaBallData({
    required this.constraints,
    required this.size,
    required this.velocity,
    this.color = Colors.cyan,
  });

  void dispose() {
    _offset.close();

    _direction.close();
  }
}
