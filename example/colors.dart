
import 'package:console/color.dart';

void main() {
  final pen = TextPen();
  for (final c in Color.getColors().entries) {
    pen.setColor(c.value);
    pen.text('${c.key}\n');
  }
  pen.print();
}
