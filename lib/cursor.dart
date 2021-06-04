import 'base.dart';

class DCCursor {
  DCCursorPosition get position => DCConsole.getCursorPosition();

  DCCursor();

  void move(int column, int row) => DCConsole.moveCursor(column: column, row: row);

  void moveUp([int times = 1]) => DCConsole.moveCursorUp(times);

  void moveDown([int times = 1]) => DCConsole.moveCursorDown(times);

  void moveLeft([int times = 1]) => DCConsole.moveCursorBack(times);

  void moveRight([int times = 1]) => DCConsole.moveCursorForward(times);

  void show() => DCConsole.showCursor();

  void hide() => DCConsole.hideCursor();

  void write(String text) => DCConsole.write(text);

  void writeAt(int column, int row, String text) {
    DCConsole.saveCursor();
    write(text);
    DCConsole.restoreCursor();
  }

  void save() => DCConsole.saveCursor();

  void restore() => DCConsole.restoreCursor();
}
