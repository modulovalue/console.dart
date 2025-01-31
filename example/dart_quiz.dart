import 'package:console/prompt.dart';

// Multiple choice quiz demonstrating various console features.
void main() {
  const dartPeople = [
    'Dan Grove',
    'Michael Thomsen',
    'Leaf Petersen',
    'Bob Nystrom',
    'Vyacheslav Egorov',
    'Kathy Walrath',
  ];
  [
    Question('What conference was Dart released at?', 'GOTO Conference',
        choices: ['Google I/O', 'GOTO Conference', 'JavaOne', 'Dart Summit']),
    Question('Who is a Product Manager for Dart at Google?', 'Michael Thomsen', choices: dartPeople),
    Question('What is the package manager for Dart called?', 'pub'),
    Question('What type of execution model does Dart have?', 'Event Loop', choices: ['Multi Threaded', 'Single Threaded', 'Event Loop']),
    Question('Does Dart have an interface keyword?', false),
    Question('Is this valid Dart code?\n  main() => print(\"Hello World\");\nAnswer: ', true),
    Question('Is this valid Dart code?\n  void main() => print(\"Hello World\");\nAnswer: ', true),
    Question('Can you use Dart in the browser?', true),
    Question('What was the first Dart to JavaScript Compiler called?', 'dartc'),
    Question('Before dart2js, what was the name of the Dart to JavaScript Compiler?', 'frog'),
  ].forEach((q) {
    questionCount++;
    final correct = q.askQuestion();
    if (correct) {
      print('Correct');
      points++;
    } else {
      print('Incorrect');
    }
  });

  results();
}

void results() {
  print('Quiz Results:');
  print('  Correct: $points');
  print('  Incorrect: ${questionCount - points}');
  print('  Score: ${((points / questionCount) * 100).toStringAsFixed(2)}%');
}

List<String> scramble(List<String> choices) {
  final out = List<String>.from(choices);
  out.shuffle();
  return out;
}

int questionCount = 0;
int points = 0;

class Question {
  final String message;
  final dynamic answer;
  final List<String>? choices;

  Question(this.message, this.answer, {this.choices});

  bool askQuestion() {
    if (choices != null) {
      print(message);
      final chooser = DCChooser<String>(scramble(choices!), message: 'Answer: ');
      return chooser.chooseSync() == answer;
    } else if (answer is String) {
      // ignore: avoid_dynamic_calls
      return DCPrompter('$message ').promptSync()?.toLowerCase().trim() == answer.toLowerCase().trim();
    } else if (answer is bool) {
      return DCPrompter('$message ').askSync() == answer;
    } else {
      throw Exception('');
    }
  }
}
