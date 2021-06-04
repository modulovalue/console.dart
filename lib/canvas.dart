import 'base.dart';
import 'cursor.dart';

abstract class DCCanvas {
  int get width;

  int get height;

  void setPixel(int x, int y, DCPixelSpec spec);
}

class DCConsoleCanvas extends DCCanvas {
  @override
  int get width => DCConsole.columns;

  @override
  int get height => DCConsole.rows;

  late List<List<DCPixelSpec>> pixels;
  late DCCursor cursor;

  DCConsoleCanvas({DCPixelSpec defaultSpec = DCPixelSpec.EMPTY}) {
    pixels = List<List<DCPixelSpec>>.generate(
      width,
      (i) => List<DCPixelSpec>.filled(height, defaultSpec),
    );
    cursor = DCCursor();
  }

  @override
  void setPixel(int x, int y, DCPixelSpec spec) {
    pixels[x][y] = spec;
  }

  void flush() {
    cursor.move(0, 0);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = pixels[x][y];
        DCConsole.write('\x1b[48;5;${pixel.color}m ');
        cursor.move(x, y);
      }
    }
  }
}

class DCPixelSpec {
  static const DCPixelSpec EMPTY = DCPixelSpec(0);

  final int color;

  const DCPixelSpec(this.color);
}
