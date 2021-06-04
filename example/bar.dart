import 'dart:async';

import 'package:console/base.dart';
import 'package:console/drawing_canvas.dart';

final canvas = DCDrawingCanvas(100, 100);

// Simple demonstration of DrawingCanvas for drawing a vertical bar.
void main() {
  DCConsole.eraseDisplay(1);
  var l = 1;
  Timer.periodic(const Duration(seconds: 2), (_) {
    l += 2;
    for (var i = 0; i < l; i++) {
      canvas.set(1, i + 1);
    }
    DCConsole.moveCursor(row: 1, column: 1);
    print(canvas.frame());
  });
}
