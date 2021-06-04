import 'package:console/keyboard.dart';

// Traps up and down arrow and echos to console.
void main() {
  DCKeyboard.init();
  DCKeyboard.bindKey('up').listen((_) {
    print('Up.');
  });
  DCKeyboard.bindKey('down').listen((_) {
    print('Down.');
  });
}
