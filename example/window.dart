import 'dart:async';
import 'dart:io';

import 'package:console/base.dart';
import 'package:console/curses/window.dart';
import 'package:console/keyboard.dart';
import 'package:console/progress.dart';

class DemoWindow extends Window {
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
      Console.centerCursor();
      Console.moveToColumn(1);
      var loader = WideLoadingBar();
      loaderTimer = loader.loop();
    }
  }

  @override
  void initialize() {
    Keyboard.bindKeys(['q', 'Q']).listen((_) {
      close();
      Console.resetAll();
      Console.eraseDisplay();
      exit(0);
    });

    Keyboard.bindKey('x').listen((_) {
      title = title == 'Hello' ? 'Goodbye' : 'Hello';
      draw();
    });

    Keyboard.bindKey(KeyCode.SPACE).listen((_) {
      showWelcomeMessage = false;
      draw();
    });

    Keyboard.bindKey('p').listen((_) {
      if (loaderTimer != null) {
        loaderTimer!.cancel();
        loaderTimer = null;
      }
    });
  }
}

void main() {
  var window = DemoWindow();
  window.display();
}
