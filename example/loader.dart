import 'dart:async';

import 'package:console/progress.dart';

void main() {
  var loader = WideLoadingBar();
  var timer = loader.loop();
  Future.delayed(const Duration(seconds: 5)).then((_) {
    timer.cancel();
  });
}
