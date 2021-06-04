
import 'dart:io';

import 'package:console/drawing_canvas.dart';

// Simple example of DrawingCanvas for a filled box.
void main() {
  final canvas = DCDrawingCanvas(120, 120);
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
