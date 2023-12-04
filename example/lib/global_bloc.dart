import 'package:rxdart/subjects.dart';

class GlobalBloc {
  static GlobalBloc? _instance;

  factory GlobalBloc() {
    _instance ??= GlobalBloc._();

    return _instance!;
  }

  static GlobalBloc get instance => GlobalBloc();

  GlobalBloc._();

  void dispose() {
    _textSize.close();

    _instance = null;
  }

  final _textSize = BehaviorSubject<double>.seeded(10);

  Stream<double> get textSize => _textSize.stream;

  Function(double) get updateTextSize => _textSize.sink.add;

  double get currentTextSize => _textSize.value;
}
