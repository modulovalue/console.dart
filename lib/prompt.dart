import 'dart:async';

import 'base.dart';

const List<String> _YES_RESPONSES = [
  'yes',
  'y',
  'sure',
  'ok',
  'yep',
  'yeah',
  'true',
  'yerp',
];

/// Emulates a Shell Prompt
class ShellPrompt {
  /// Shell Prompt
  String message;
  bool _stop = false;

  ShellPrompt({this.message = r'$ '});

  /// Stops a Loop
  void stop() => _stop = true;

  /// Runs a shell prompt in a loop.
  Stream<String> loop() {
    // ignore: close_sinks
    final controller = StreamController<String>();
    late void Function() doRead;
    doRead = () {
      if (_stop) {
        _stop = false;
      } else {
        Prompter(message).prompt().then((it) {
          controller.add(it);
          Future<void>(doRead);
        });
      }
    };
    Future<void>(doRead);
    return controller.stream;
  }
}

class Chooser<T> {
  final String message;
  final List<T> choices;
  final ChooserEntryFormatter<T> formatter;

  Chooser(this.choices, {this.message = 'Choice: ', this.formatter = _defaultFormatter});

  static String _defaultFormatter(dynamic input, int index) => '[$index] $input';

  T chooseSync() {
    final buff = StringBuffer();
    var i = -1;
    for (final choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }
    buff.write(message);
    for (;;) {
      final input = Prompter(buff.toString()).promptSync();
      final result = _parseInteger(input ?? '');
      if (result == null && input != null) {
        final exists = choices.map((it) => it.toString().trim().toLowerCase()).contains(input.trim().toLowerCase());
        if (exists) {
          final val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() == input.trim().toLowerCase();
          });
          return val;
        }
      }
      try {
        if (result != null) {
          return choices[result - 1];
        }
        // ignore: empty_catches, avoid_catches_without_on_clauses
      } catch (e) {}
    }
  }

  Future<dynamic> choose() {
    final buff = StringBuffer();
    var i = -1;
    for (final choice in choices) {
      i++;
      buff.writeln(formatter(choice, i + 1));
    }
    buff.write(message);
    final completer = Completer<T>();
    late void Function(String) process;
    process = (String input) {
      final result = _parseInteger(input);
      if (result == null) {
        final exists = choices.map((it) => it.toString().trim().toLowerCase()).contains(input.trim().toLowerCase());
        if (exists) {
          final val = choices.firstWhere((it) {
            return it.toString().trim().toLowerCase() == input.trim().toLowerCase();
          });
          completer.complete(val);
          return;
        }
      }
      T choice;
      try {
        if (result == null) {
          Prompter(buff.toString()).prompt().then(process);
        } else {
          choice = choices[result - 1];
          completer.complete(choice);
        }
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Prompter(buff.toString()).prompt().then(process);
      }
    };
    Prompter(buff.toString()).prompt().then(process);
    return completer.future;
  }
}

typedef ChooserEntryFormatter<T> = String Function(T choice, int index);

class Prompter {
  final String message;
  final bool secret;

  const Prompter(this.message, {this.secret = false});

  /// Prompts a user for a yes or no answer.
  ///
  /// The following are considered yes responses:
  ///
  /// - yes
  /// - y
  /// - sure
  /// - ok
  /// - yep
  /// - yeah
  /// - true
  /// - yerp
  ///
  /// You can add more to the list of positive responses using the [positive] argument.
  ///
  /// The input will be changed to lowercase and then checked.
  bool? askSync({List<String> positive = const []}) {
    final answer = promptSync();
    if (answer == null) {
      // ignore: avoid_returning_null
      return null;
    } else {
      return _YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase());
    }
  }

  Future<bool> ask({List<String> positive = const []}) {
    return prompt().then((answer) {
      return _YES_RESPONSES.contains(answer.toLowerCase()) || positive.contains(message.toLowerCase());
    });
  }

  String? promptSync({ResponseChecker? checker}) {
    for (;;) {
      Console.adapter.write(message);
      if (secret) Console.adapter.echoMode = false;
      final response = Console.readLine();
      if (secret) {
        Console.adapter.echoMode = true;
        print('');
      }
      if ((checker != null && response != null) ? checker(response) : true) {
        return response;
      }
    }
  }

  Future<String> prompt({ResponseChecker? checker}) {
    final completer = Completer<String>();
    late void Function() doAsk;
    doAsk = () {
      Console.adapter.write(message);
      Future(() {
        if (secret) Console.adapter.echoMode = false;
        final response = Console.readLine();
        if (secret) Console.adapter.echoMode = true;
        if (checker != null && response != null && !checker(response)) {
          doAsk();
          return;
        }
        completer.complete(response);
      });
    };
    doAsk();
    return completer.future;
  }
}

Future<String> readInput(String message, {bool secret = false, ResponseChecker? checker}) {
  return Prompter(message, secret: secret).prompt(checker: checker);
}

typedef ResponseChecker = bool Function(String response);

int? _parseInteger(String input) => int.tryParse(input);
