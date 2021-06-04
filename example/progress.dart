import 'dart:async';

import 'package:console/progress.dart';

// Demonstrates a determinate progress bar (e.g. download)
void main() {
  final progress = DCProgressBar();
  var i = 0;
  Timer.periodic(const Duration(milliseconds: 300), (timer) {
    i++;
    progress.update(i);
    if (i == 100) {
      timer.cancel();
    }
  });
}
