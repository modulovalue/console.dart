import 'package:console/cursor.dart';

// Shows use of cursor positioning operations.
void main() {
  final cursor = DCCursor();
  cursor.moveDown(3);
  cursor.write('3: This is the third line.');
  cursor.moveUp(1);
  cursor.write('2: This is the second line.');
  cursor.moveUp(1);
  cursor.write('1: This is the first line.');
}
