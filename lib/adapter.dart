import 'dart:async';
import 'dart:io';

abstract class DCConsoleAdapter {
  int get rows;

  int get columns;

  void write(String? data);

  void writeln(String? data);

  String? read();

  int readByte();

  Stream<List<int>> byteStream();

  bool get echoMode;

  set echoMode(bool value);

  bool get lineMode;

  set lineMode(bool value);
}

class DCStdioConsoleAdapter extends DCConsoleAdapter {
  @override
  int get columns => stdout.terminalColumns;

  @override
  int get rows => stdout.terminalLines;

  @override
  String? read() => stdin.readLineSync();

  @override
  Stream<List<int>> byteStream() => stdin;

  @override
  void write(String? data) {
    stdout.write(data);
  }

  @override
  void writeln(String? data) {
    stdout.writeln(data);
  }

  @override
  set echoMode(bool value) {
    stdin.echoMode = value;
  }

  @override
  bool get echoMode => stdin.echoMode;

  @override
  set lineMode(bool value) {
    stdin.lineMode = value;
  }

  @override
  bool get lineMode => stdin.lineMode;

  @override
  int readByte() => stdin.readByteSync();
}

class DCBufferConsoleAdapter extends DCConsoleAdapter {
  StringBuffer buffer = StringBuffer();
  String input = '';

  @override
  int get columns => 80;

  @override
  int get rows => 20;

  @override
  String read() => input;

  @override
  Stream<List<int>> byteStream() {
    // ignore: close_sinks
    final c = StreamController<List<int>>();
    Future(() {
      c.add(input.codeUnits);
      c.add('\n'.codeUnits);
    });
    return c.stream;
  }

  @override
  void write(String? data) {
    buffer.write(data);
  }

  @override
  void writeln(String? data) {
    buffer.writeln(data);
  }

  @override
  bool echoMode = true;
  @override
  bool lineMode = true;

  @override
  int readByte() => 0;

  void clear() => buffer.clear();

  @override
  String toString() => buffer.toString();
}
