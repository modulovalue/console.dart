import 'dart:async';
import 'dart:io';

import 'base.dart';
import 'keyboard.dart';

abstract class DCWindow {
  String title;
  Timer? _updateTimer;

  DCWindow(this.title) {
    _init();
    initialize();
  }

  void initialize();

  void _init() {
    stdin.echoMode = false;
    DCConsole.onResize.listen((dynamic _) => draw());
    DCKeyboard.echoUnhandledKeys = false;
  }

  void draw() {
    DCConsole.eraseDisplay(2);
    final width = DCConsole.columns;
    DCConsole.moveCursor(row: 1, column: 1);
    DCConsole.setBackgroundColor(7, bright: true);
    _repeatFunction((dynamic i) => DCConsole.write(' '), width);
    DCConsole.setTextColor(0);
    DCConsole.moveCursor(
      row: 1,
      column: (DCConsole.columns / 2).round() - (title.length / 2).round(),
    );
    DCConsole.write(title);
    _repeatFunction((dynamic i) => DCConsole.write('\n'), DCConsole.rows - 1);
    DCConsole.moveCursor(row: 2, column: 1);
    DCConsole.centerCursor(row: true);
    DCConsole.resetBackgroundColor();
  }

  void display() {
    draw();
  }

  Timer? startUpdateLoop([Duration? wait]) {
    wait ??= const Duration(seconds: 2);
    return _updateTimer = Timer.periodic(wait, (timer) => draw());
  }

  void close() {
    if (_updateTimer != null) {
      _updateTimer!.cancel();
    }
    DCConsole.eraseDisplay();
    DCConsole.moveCursor(row: 1, column: 1);
    stdin.echoMode = true;
  }

  void writeCentered(String text) {
    final column = ((DCConsole.columns / 2) - (text.length / 2)).round();
    final row = (DCConsole.rows / 2).round();
    DCConsole.moveCursor(row: row, column: column);
    DCConsole.write(text);
  }
}

void _repeatFunction(Function func, int times) {
  for (var i = 1; i <= times; i++) {
    // ignore: avoid_dynamic_calls
    func(i);
  }
}
