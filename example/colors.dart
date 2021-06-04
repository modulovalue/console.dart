import 'package:console/base.dart';

// Setting colored output with the TextPen class.
void main() {
  final pen = DCTextPen();
  for (final c in DCColor.getColors().entries) {
    pen.setColor(c.value);
    pen.text('${c.key}\n');
  }
  pen.print();
}
