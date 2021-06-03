import 'package:console/canvas.dart';

void main() {
  final canvas = ConsoleCanvas(defaultSpec: const PixelSpec(color: 0));
  for (var i = 0; i < 5; i++) {
    canvas.setPixel(i, i, 170);
  }
  canvas.flush();
}
