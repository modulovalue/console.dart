import 'dart:async';

import 'package:console/base.dart';
import 'package:console/timer.dart';

// Example of a timer.
void main() {
  final timer = DCTimeDisplay();
  DCConsole.write('Waiting 10 Seconds ');
  timer.start();
  Future<dynamic >.delayed(const Duration(seconds: 10)).then((dynamic _) {
    timer.stop();
    print('');
  });
}
