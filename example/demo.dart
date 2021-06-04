import 'package:console/base.dart';
import 'package:console/icons.dart';
import 'package:console/progress.dart';

// Shows basic console formatting options.
void main() {
  DCConsole.init();
  print('Demo of Console Features');
  print('------------------------');
  DCConsole.setCrossedOut(true);
  print('Crossed Out');
  DCConsole.setCrossedOut(false);
  DCConsole.setBold(true);
  print('Bold');
  DCConsole.setBold(false);
  DCConsole.setTextColor(1, bright: true);
  print('Bright Red');
  DCConsole.resetAll();
  print('Progress Bar');
  final bar = DCProgressBar(complete: 5);
  bar.update(3);
  print('${DCIcons.checkmark} Icons');
  print('Icon ${DCIcons.checkmark}');
  print('Icon ${DCIcons.ballotX}');
  print('Icon ${DCIcons.refresh}');
  print('Icon ${DCIcons.heavyCheckmark}');
  print('Icon ${DCIcons.heayBallotX}');
  print('Icon ${DCIcons.star}');
}
