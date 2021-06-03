
import 'dart:io';

import 'package:console/drawing_canvas.dart';

void main() {
  final canvas = DrawingCanvas(120, 120);
  void draw() {
    for (var x = 1; x < canvas.width; x++) {
      for (var y = 1; y < canvas.height; y++) {
        canvas.set(x, y);
      }
    }
    print(canvas.frame());
  }
  for (;;) {
    draw();
    sleep(const Duration(milliseconds: 16));
  }
}
