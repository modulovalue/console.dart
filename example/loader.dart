import 'dart:async';

import 'package:console/progress.dart';

// Demonstrates an indeterminate progress bar.
void main() {
  final loader = DCWideLoadingBar();
  final timer = loader.loop();
  Future<dynamic>.delayed(const Duration(seconds: 5)).then((dynamic _) {
    timer.cancel();
  });
}
