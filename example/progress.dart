import 'dart:async';

import 'package:console/progress.dart';

void main() {
  final progress = ProgressBar();
  var i = 0;
  Timer.periodic(const Duration(milliseconds: 300), (timer) {
    i++;
    progress.update(i);
    if (i == 100) {
      timer.cancel();
    }
  });
}
