import 'package:console/base.dart';
import 'package:console/icons.dart';
import 'package:console/progress.dart';

void main() {
  Console.init();
  print('Demo of Console Features');
  print('------------------------');
  Console.setCrossedOut(true);
  print('Crossed Out');
  Console.setCrossedOut(false);
  Console.setBold(true);
  print('Bold');
  Console.setBold(false);
  Console.setTextColor(1, bright: true);
  print('Bright Red');
  Console.resetAll();
  print('Progress Bar');
  final bar = ProgressBar(complete: 5);
  bar.update(3);
  print('${Icon.checkmark} Icons');
  print('Icon ${Icon.checkmark}');
  print('Icon ${Icon.ballotX}');
  print('Icon ${Icon.refresh}');
  print('Icon ${Icon.heavyCheckmark}');
  print('Icon ${Icon.heayBallotX}');
  print('Icon ${Icon.star}');
  print('');
  print('Icon ${Icon.VERTICAL_LINE}');
  print('Icon ${Icon.HORIZONTAL_LINE}');
  print('Icon ${Icon.LEFT_VERTICAL_LINE}');
  print('Icon ${Icon.LOW_LINE}');
  print('Icon ${Icon.PIPE_VERTICAL}');
  print('Icon ${Icon.PIPE_LEFT_HALF_VERTICAL}');
  print('Icon ${Icon.PIPE_LEFT_VERTICAL}');
  print('Icon ${Icon.PIPE_HORIZONTAL}');
  print('Icon ${Icon.PIPE_BOTH}');
  print('Icon ${Icon.HEAVY_VERTICAL_BAR}');
}
