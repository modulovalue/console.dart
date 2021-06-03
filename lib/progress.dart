import 'dart:async';

import 'base.dart';

/// A fancy progress bar
class ProgressBar {
  final int complete;

  int current = 0;

  /// Creates a Progress Bar.
  ///
  /// [complete] is the number that is considered 100%.
  ProgressBar({this.complete = 100});

  /// Updates the Progress Bar with a progress of [progress].
  void update(int progress) {
    if (progress == current) {
      return;
    }
    current = progress;
    final ratio = progress / complete;
    final percent = (ratio * 100).toInt();
    final digits = percent.toString().length;
    final w = Console.columns - digits - 4;
    final count = (ratio * w).toInt();
    final before = '$percent% [';
    const after = ']';
    final out = StringBuffer(before);
    for (var x = 1; x < count; x++) {
      out.write('=');
    }
    out.write('>');
    for (var x = count; x < w; x++) {
      out.write(' ');
    }
    out.write(after);
    if (out.length - 1 == Console.columns) {
      final it = out.toString();
      out.clear();
      out.write(it.substring(0, it.length - 2) + ']');
    }
    Console.overwriteLine(out.toString());
  }
}

/// Specifies the next position of the loading bar
typedef NextPositionLoadingBar = void Function();

/// A loading bar
class LoadingBar {
  Timer? _timer;
  bool started = true;
  String position = '<';
  late String lastPosition;
  late NextPositionLoadingBar nextPosition;

  /// Creates a loading bar.
  LoadingBar() {
    nextPosition = _nextPosition;
  }

  /// Starts the Loading Bar
  void start() {
    Console.hideCursor();
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      nextPosition();
      update();
    });
  }

  /// Stops the Loading Bar with the specified (and optional) [message].
  void stop([String? message]) {
    if (_timer != null) {
      _timer!.cancel();
    }

    if (message != null) {
      position = message;
      update();
    }
    Console.showCursor();
    print('');
  }

  /// Updates the Loading Bar
  void update() {
    if (started) {
      Console.write(position);
      started = false;
    } else {
      Console.moveCursorBack(lastPosition.length);
      Console.write(position);
    }
  }

  void _nextPosition() {
    lastPosition = position;
    switch (position) {
      case '|':
        position = '/';
        break;
      case '/':
        position = '-';
        break;
      case '-':
        position = '\\';
        break;
      case '\\':
        position = '|';
        break;
      default:
        position = '|';
        break;
    }
  }
}

/// A wide loading bar. Kind of like a Progress Bar.
class WideLoadingBar {
  int position = 0;

  /// Creates a wide loading bar.
  WideLoadingBar();

  /// Loops the loading bar.
  Timer loop() {
    final width = Console.columns - 2;
    var goForward = true;
    var isDone = true;

    return Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      if (!isDone) {
        return;
      }

      isDone = false;

      for (var i = 1; i <= width; i++) {
        position = i;
        await Future<void>.delayed(const Duration(milliseconds: 5));
        if (goForward) {
          forward();
        } else {
          backward();
        }
      }
      goForward = !goForward;
      isDone = true;
    });
  }

  /// Moves the Bar Forward
  void forward() {
    final out = StringBuffer('[');
    final width = Console.columns - 2;
    final after = width - position;
    final before = width - after - 1;
    for (var i = 1; i <= before; i++) {
      out.write(' ');
    }
    out.write('=');
    for (var i = 1; i <= after; i++) {
      out.write(' ');
    }
    out.write(']');
    Console.overwriteLine(out.toString());
  }

  /// Moves the Bar Backward
  void backward() {
    final out = StringBuffer('[');
    final width = Console.columns - 2;
    final before = width - position;
    final after = width - before - 1;
    for (var i = 1; i <= before; i++) {
      out.write(' ');
    }
    out.write('=');
    for (var i = 1; i <= after; i++) {
      out.write(' ');
    }
    out.write(']');
    Console.overwriteLine(out.toString());
  }
}
