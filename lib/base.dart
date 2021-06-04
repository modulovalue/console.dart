import 'dart:io';

import 'adapter.dart';

/// The root of the console API
class DCConsole {
  static const String ANSI_CODE = '\x1b';

  /// ANSI Escape Code
  static const String ANSI_ESCAPE = '\x1b[';
  static bool _cursorCTRLC = false;
  static bool _buffCTRLC = false;
  static bool initialized = false;
  static DCColor? _currentTextColor;
  static DCColor? _currentBackgroundColor;
  static DCConsoleAdapter adapter = DCStdioConsoleAdapter();

  /// Initializes the Console
  static void init() {
    if (!initialized) {
      initialized = true;
    }
  }

  static Stream<dynamic> get onResize => ProcessSignal.sigwinch.watch();

  /// Moves the Cursor Forward the specified amount of [times].
  static void moveCursorForward([int times = 1]) => writeANSI('${times}C');

  /// Moves the Cursor Back the specified amount of [times].
  static void moveCursorBack([int times = 1]) => writeANSI('${times}D');

  /// Moves the Cursor Up the specified amount of [times].
  static void moveCursorUp([int times = 1]) => writeANSI('${times}A');

  /// Moves the Cursor Down the specified amount of [times].
  static void moveCursorDown([int times = 1]) => writeANSI('${times}B');

  /// Erases the Display
  static void eraseDisplay([int type = 0]) => writeANSI('${type}J');

  /// Erases the Line
  static void eraseLine([int type = 0]) => writeANSI('${type}K');

  /// Moves the the column specified in [number].
  static void moveToColumn(int number) => writeANSI('${number}G');

  /// Overwrites the current line with [line].
  static void overwriteLine(String line) {
    write('\r');
    eraseLine(2);
    write(line);
  }

  /// Sets the Current Text Color.
  static void setTextColor(int id, {bool xterm = false, bool bright = false}) {
    DCColor color;
    if (xterm) {
      final c = id.clamp(0, 256);
      color = DCColor(c, xterm: true);
      sgr(38, [5, c]);
    } else {
      color = DCColor(id, bright: true);
      if (bright) {
        sgr(30 + id, [1]);
      } else {
        sgr(30 + id);
      }
    }
    _currentTextColor = color;
  }

  static DCColor? getTextColor() => _currentTextColor;

  static DCColor? getBackgroundColor() => _currentBackgroundColor;

  static void hideCursor() {
    if (!_cursorCTRLC) {
      ProcessSignal.sigint.watch().listen((signal) {
        showCursor();
        exit(0);
      });
      _cursorCTRLC = true;
    }
    writeANSI('?25l');
  }

  static void showCursor() {
    writeANSI('?25h');
  }

  static void altBuffer() {
    if (!_buffCTRLC) {
      ProcessSignal.sigint.watch().listen((signal) {
        normBuffer();
        exit(0);
      });
      _buffCTRLC = true;
    }
    writeANSI('?47h');
  }

  static void normBuffer() {
    writeANSI('?47l');
  }

  static void setBackgroundColor(int id, {bool xterm = false, bool bright = false}) {
    DCColor color;
    if (xterm) {
      final c = id.clamp(0, 256);
      color = DCColor(c, xterm: true);
      sgr(48, [5, c]);
    } else {
      color = DCColor(id, bright: true);
      if (bright) {
        sgr(40 + id, [1]);
      } else {
        sgr(40 + id);
      }
    }
    _currentBackgroundColor = color;
  }

  static void centerCursor({bool row = true}) {
    if (row) {
      final column = (columns / 2).round();
      final row = (rows / 2).round();
      moveCursor(row: row, column: column);
    } else {
      moveToColumn((columns / 2).round());
    }
  }

  static void moveCursor({int? row, int? column}) {
    var out = '';
    if (row != null) {
      out += row.toString();
    }
    out += ';';
    if (column != null) {
      out += column.toString();
    }
    writeANSI('${out}H');
  }

  static void setBold(bool bold) => sgr(bold ? 1 : 22);

  static void setItalic(bool italic) => sgr(italic ? 3 : 23);

  static void setBlink(bool blink) => sgr(blink ? 5 : 25);

  static void setUnderline(bool underline) => sgr(underline ? 4 : 24);

  static void setCrossedOut(bool crossedOut) => sgr(crossedOut ? 9 : 29);

  static void setFramed(bool framed) => sgr(framed ? 51 : 54);

  static void setEncircled(bool encircled) => sgr(encircled ? 52 : 54);

  static void setOverlined(bool overlined) => sgr(overlined ? 53 : 55);

  static void setInverted(bool flipped) => sgr(flipped ? 7 : 27);

  static void conceal() => sgr(8);

  static void reveal() => sgr(28);

  static void resetAll() {
    sgr(0);
    _currentTextColor = null;
    _currentBackgroundColor = null;
  }

  static void resetTextColor() {
    sgr(39);
    _currentTextColor = null;
  }

  static void resetBackgroundColor() {
    sgr(49);
    _currentBackgroundColor = null;
  }

  static void sgr(int id, [List<int>? params]) {
    String stuff;
    if (params != null) {
      stuff = "$id;${params.join(";")}";
    } else {
      stuff = id.toString();
    }
    writeANSI('${stuff}m');
  }

  static int get rows => adapter.rows;

  static int get columns => adapter.columns;

  static void nextLine([int times = 1]) => writeANSI('${times}E');

  static void previousLine([int times = 1]) => writeANSI('${times}F');

  static void write(String? content) {
    init();
    adapter.write(content);
  }

  static String? readLine() => adapter.read();

  static void writeANSI(String after) => write('$ANSI_ESCAPE$after');

  static DCCursorPosition getCursorPosition() {
    final lm = adapter.lineMode;
    final em = adapter.echoMode;
    adapter.lineMode = false;
    adapter.echoMode = false;
    writeANSI('6n');
    final bytes = <int>[];
    for (;;) {
      final byte = adapter.readByte();
      bytes.add(byte);
      if (byte == 82) {
        break;
      }
    }
    adapter.lineMode = lm;
    adapter.echoMode = em;
    var str = String.fromCharCodes(bytes);
    str = str.substring(str.lastIndexOf('[') + 1, str.length - 1);
    final parts = List<int>.from(str.split(';').map<int>((it) => int.parse(it))).toList();
    return DCCursorPosition(parts[1], parts[0]);
  }

  static void saveCursor() => writeANSI('s');

  static void restoreCursor() => writeANSI('u');
}

class DCCursorPosition {
  final int row;
  final int column;

  const DCCursorPosition(this.column, this.row);

  @override
  String toString() => '($column, $row)';
}

final Map<String, DCColor> DCCOLORS = {
  'black': const DCColor(0),
  'gray': const DCColor(0, bright: true),
  'dark_red': const DCColor(1),
  'red': const DCColor(1, bright: true),
  'green': const DCColor(2),
  'lime': const DCColor(2, bright: true),
  'gold': const DCColor(3),
  'yellow': const DCColor(3, bright: true),
  'dark_blue': const DCColor(4),
  'blue': const DCColor(4, bright: true),
  'magenta': const DCColor(5),
  'light_magenta': const DCColor(5, bright: true),
  'cyan': const DCColor(6),
  'light_cyan': const DCColor(6, bright: true),
  'light_gray': const DCColor(7),
  'white': const DCColor(7, bright: true)
};

class DCColor {
  static const DCColor BLACK = DCColor(0);
  static const DCColor GRAY = DCColor(0, bright: true);
  static const DCColor RED = DCColor(1, bright: true);
  static const DCColor DARK_RED = DCColor(1);
  static const DCColor LIME = DCColor(2, bright: true);
  static const DCColor GREEN = DCColor(2);
  static const DCColor GOLD = DCColor(3);
  static const DCColor YELLOW = DCColor(3, bright: true);
  static const DCColor BLUE = DCColor(4, bright: true);
  static const DCColor DARK_BLUE = DCColor(4);
  static const DCColor MAGENTA = DCColor(5);
  static const DCColor LIGHT_MAGENTA = DCColor(5, bright: true);
  static const DCColor CYAN = DCColor(6);
  static const DCColor LIGHT_CYAN = DCColor(6, bright: true);
  static const DCColor LIGHT_GRAY = DCColor(7);
  static const DCColor WHITE = DCColor(7, bright: true);

  final int id;
  final bool xterm;
  final bool bright;

  const DCColor(this.id, {this.xterm = false, this.bright = false});

  static Map<String, DCColor> getColors() => DCCOLORS;

  void makeCurrent({bool background = false}) {
    if (background) {
      DCConsole.setBackgroundColor(id, xterm: xterm, bright: bright);
    } else {
      DCConsole.setTextColor(id, xterm: xterm, bright: bright);
    }
  }

  @override
  String toString({bool background = false}) {
    if (xterm) {
      return '${DCConsole.ANSI_ESCAPE}${background ? 38 : 48};5;${id}m';
    }
    if (bright) {
      return '${DCConsole.ANSI_ESCAPE}1;${(background ? 40 : 30) + id}m';
    } else {
      return '${DCConsole.ANSI_ESCAPE}0;${(background ? 40 : 30) + id}m';
    }
  }
}

class DCTextPen {
  final StringBuffer buffer;

  DCTextPen({
    StringBuffer? buffer,
  }) : buffer = buffer ?? StringBuffer();

  DCTextPen black() => setColor(DCColor.BLACK);

  DCTextPen blue() => setColor(DCColor.BLUE);

  DCTextPen red() => setColor(DCColor.RED);

  DCTextPen darkRed() => setColor(DCColor.DARK_RED);

  DCTextPen lime() => setColor(DCColor.LIME);

  DCTextPen green() => setColor(DCColor.GREEN);

  DCTextPen gold() => setColor(DCColor.GOLD);

  DCTextPen yellow() => setColor(DCColor.YELLOW);

  DCTextPen darkBlue() => setColor(DCColor.DARK_BLUE);

  DCTextPen magenta() => setColor(DCColor.MAGENTA);

  DCTextPen lightMagenta() => setColor(DCColor.LIGHT_MAGENTA);

  DCTextPen cyan() => setColor(DCColor.CYAN);

  DCTextPen lightCyan() => setColor(DCColor.LIGHT_CYAN);

  DCTextPen lightGray() => setColor(DCColor.LIGHT_GRAY);

  DCTextPen white() => setColor(DCColor.WHITE);

  DCTextPen gray() => setColor(DCColor.GRAY);

  // ignore: avoid_returning_this
  DCTextPen normal() {
    buffer.write(DCConsole.ANSI_ESCAPE + '0m');
    return this;
  }

  // ignore: avoid_returning_this
  DCTextPen text(String input) {
    buffer.write(input);
    return this;
  }

  // ignore: avoid_returning_this
  DCTextPen setColor(DCColor color) {
    buffer.write(color.toString());
    return this;
  }

  // ignore: avoid_returning_this
  DCTextPen print() {
    normal();
    DCConsole.adapter.writeln(buffer.toString());
    return this;
  }

  // ignore: avoid_returning_this
  DCTextPen reset() {
    buffer.clear();
    return this;
  }

  void call([String? input]) {
    if (input != null) {
      text(input);
    } else {
      print();
    }
  }

  @override
  String toString() => buffer.toString();
}
