import 'dart:async';
import 'dart:io';

import 'package:console/base.dart';
import 'package:console/keyboard.dart';
import 'package:console/progress.dart';
import 'package:console/window.dart';

// Example of a full-screen window, as needed for a text editor.
void main() {
  final window = DemoWindow();
  window.display();
}

class DemoWindow extends DCWindow {
  bool showWelcomeMessage = true;
  Timer? loaderTimer;

  DemoWindow() : super('Hello');

  @override
  void draw() {
    super.draw();

    if (loaderTimer != null) {
      loaderTimer!.cancel();
    }

    if (showWelcomeMessage) {
      writeCentered('Welcome!');
    } else {
      DCConsole.centerCursor();
      DCConsole.moveToColumn(1);
      final loader = DCWideLoadingBar();
      loaderTimer = loader.loop();
    }
  }

  @override
  void initialize() {
    DCKeyboard.bindKeys(['q', 'Q']).listen((_) {
      close();
      DCConsole.resetAll();
      DCConsole.eraseDisplay();
      exit(0);
    });

    DCKeyboard.bindKey('x').listen((_) {
      title = title == 'Hello' ? 'Goodbye' : 'Hello';
      draw();
    });

    DCKeyboard.bindKey(DCKeyCode.SPACE).listen((_) {
      showWelcomeMessage = false;
      draw();
    });

    DCKeyboard.bindKey('p').listen((_) {
      if (loaderTimer != null) {
        loaderTimer!.cancel();
        loaderTimer = null;
      }
    });
  }
}
