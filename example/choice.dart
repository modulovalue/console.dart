
import 'package:console/prompt.dart';

void main() {
  var chooser = Chooser<String>(
    ['A', 'B', 'C', 'D'],
    message: 'Select a Letter: ',
  );
  var letter = chooser.chooseSync();
  print('You chose ${letter}.');
}
