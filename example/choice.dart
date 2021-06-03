
import 'package:console/prompt.dart';

void main() {
  final chooser = Chooser<String>(
    ['A', 'B', 'C', 'D'],
    message: 'Select a Letter: ',
  );
  final letter = chooser.chooseSync();
  print('You chose $letter.');
}
