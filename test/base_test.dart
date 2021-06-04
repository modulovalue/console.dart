library console.test.base;

import 'dart:convert';

import 'package:console/adapter.dart';
import 'package:console/base.dart';
import 'package:test/test.dart';

void main() {
  final output = DCBufferConsoleAdapter();
  setUpAll(() => DCConsole.adapter = output);
  setUp(() => output.clear());
  group('base functions', () {
    test('centerCursor', () {
      DCConsole.centerCursor();
      expect(output, ansi('10;40H'));
    });
    test('hideCursor', () {
      DCConsole.hideCursor();
      expect(output, ansi('?25l'));
    });
    test('showCursor', () {
      DCConsole.showCursor();
      expect(output, ansi('?25h'));
    });
    test('moveCursorForward', () {
      DCConsole.moveCursorForward(1);
      expect(output, ansi('1C'));
    });
    test('moveCursorBack', () {
      DCConsole.moveCursorBack(1);
      expect(output, ansi('1D'));
    });
    test('moveCursorUp', () {
      DCConsole.moveCursorUp(1);
      expect(output, ansi('1A'));
    });
    test('moveCursorDown', () {
      DCConsole.moveCursorDown(1);
      expect(output, ansi('1B'));
    });
  });
}

class ANSIMatcher extends Matcher {
  final String value;

  const ANSIMatcher(this.value);

  @override
  Description describe(Description description) => description;

  @override
  bool matches(dynamic item, Map<dynamic, dynamic> matchState) => item.toString() == '${DCConsole.ANSI_ESCAPE}$value';

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription, Map<dynamic, dynamic> matchState, bool verbose) =>
      mismatchDescription.add('${utf8.encode(item.toString())} != '
          ' ${utf8.encode(value.toString())}');
}

Matcher ansi(String value) => ANSIMatcher(value);
