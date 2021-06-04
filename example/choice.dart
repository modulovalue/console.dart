
import 'package:console/prompt.dart';

// Select a multiple choice option.
void main() {
  final chooser = DCChooser<String>(
    ['A', 'B', 'C', 'D'],
    message: 'Select a Letter: ',
  );
  final letter = chooser.chooseSync();
  print('You chose $letter.');
}
