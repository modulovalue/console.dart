import 'dart:async';
import 'dart:math' as math;

import 'package:console/base.dart';
import 'package:console/drawing_canvas.dart';
import 'package:console/utils.dart';

final canvas = DCDrawingCanvas(160, 160);

// Sophisticated example of using DrawingCanvas to display a clock.
void main() {
  Timer.periodic(
    const Duration(milliseconds: 1000 ~/ 24),
    (t) => draw(),
  );
}

void draw() {
  canvas.clear();
  final time = DateTime.now();
  bresenham(80, 80, sin(time.hour / 24, 30), 160 - cos(time.hour / 24, 30), canvas.set);
  bresenham(80, 80, sin(time.minute / 60, 50), 160 - cos(time.minute / 60, 50), canvas.set);
  bresenham(
    80,
    80,
    sin(time.second / 60 + (time.millisecondsSinceEpoch % 1000 / 60000), 75),
    160 - cos(time.second / 60 + (time.millisecondsSinceEpoch % 1000) / 60000, 75),
    canvas.set,
  );
  DCConsole.write(canvas.frame());
}

num sin(num i, num l) => (math.sin(i * 2 * math.pi) * l + 80).floor();

num cos(num i, num l) => (math.cos(i * 2 * math.pi) * l + 80).floor();
