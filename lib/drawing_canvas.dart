class DCDrawingCanvas {
  static final List<List<int>> _map = [
    [0x1, 0x8],
    [0x2, 0x10],
    [0x4, 0x20],
    [0x40, 0x80]
  ];
  final int width;
  final int height;
  late List<int> content;

  DCDrawingCanvas(this.width, this.height) {
    if (width % 2 != 0) {
      throw Exception('Width must be a multiple of 2!');
    }
    if (height % 4 != 0) {
      throw Exception('Height must be a multiple of 4!');
    }
    content = List<int>.filled(width * height ~/ 8, 0);
    _fillContent();
  }

  void _doIt(int x, int y, void Function(int coord, int mask) func) {
    if (!(x >= 0 && x < width && y >= 0 && y < height)) {
      return;
    }
    // ignore: parameter_assignments
    x = x.floor();
    // ignore: parameter_assignments
    y = y.floor();
    final nx = (x / 2).floor();
    final ny = (y / 4).floor();
    final coord = (nx + width / 2 * ny).toInt();
    final mask = _map[y % 4][x % 2];
    func(coord, mask);
  }

  void _fillContent([int byte = 0]) {
    for (var i = 0; i < content.length; i++) {
      content[i] = byte;
    }
  }

  void clear() {
    _fillContent();
  }

  void set(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] |= mask;
    });
  }

  void unset(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] &= mask;
    });
  }

  void toggle(int x, int y) {
    _doIt(x, y, (coord, mask) {
      content[coord] ^= mask;
    });
  }

  String frame([String delimiter = '\n']) {
    final result = <String>[];
    for (var i = 0, j = 0; i < content.length; i++, j++) {
      if (j == width / 2) {
        result.add(delimiter);
        j = 0;
      }
      if (content[i] == 0) {
        result.add(' ');
      } else {
        result.add(String.fromCharCode(0x2800 + content[i]));
      }
    }
    result.add(delimiter);
    return result.join();
  }
}
