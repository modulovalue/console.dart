import 'dart:async';

import 'package:console/progress.dart';

void main() {
  final loader = WideLoadingBar();
  final timer = loader.loop();
  Future<dynamic>.delayed(const Duration(seconds: 5)).then((dynamic _) {
    timer.cancel();
  });
}
