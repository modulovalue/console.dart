import 'package:console/prompt.dart';

//  A simple REPL that echoes input text back to the console.
void main() {
  final shell = DCShellPrompt();
  shell.loop().listen((line) {
    if (['stop', 'quit', 'exit'].contains(line.toLowerCase().trim())) {
      shell.stop();
      return;
    }
    print(line);
  });
}
