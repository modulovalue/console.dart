import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'base.dart';

/// API for the Keyboard
class DCKeyboard {
  static final Map<String, StreamController<String>> _handlers = {};

  static bool _initialized = false;

  /// Display input that is not handled.
  static bool echoUnhandledKeys = true;

  /// Initialize Keyboard System
  static void init() {
    if (!_initialized) {
      stdin.echoMode = false;
      stdin.lineMode = false;
      _initialized = true;
      DCConsole.adapter.byteStream().asBroadcastStream().map((bytes) {
        final it = ascii.decode(bytes);
        final original = bytes;
        var code = it.replaceAll(DCConsole.ANSI_CODE, '');
        if (code.isNotEmpty) {
          code = code.substring(1);
        }
        if (inputSequences[code] != null) {
          return [original, inputSequences[code]];
        } else {
          return [original, it];
        }
      }).listen((List<dynamic> m) {
        handleKey(m[0] as List<int>?, m[1] as String);
      });
    }
  }

  static void handleKey(List<int>? bytes, String? name) {
    if (name == null) {
      return;
    }
    if (_handlers.containsKey(name)) {
      _handlers[name]!.add(name);
      return;
    }
    if (!echoUnhandledKeys) {
      return;
    }
    if (bytes == null) {
      return;
    }
    if (bytes.length == 1 && bytes[0] == 127) {
      if (Platform.isMacOS) {
        DCConsole.moveCursorBack(1);
      } else {
        stdout.write('\b \b');
        return;
      }
    }
    stdout.add(bytes);
    if (bytes.length == 1 && bytes[0] == 127) {
      DCConsole.moveCursorBack(1);
    }
  }

  static Stream<String> bindKey(String code) {
    init();
    if (_handlers.containsKey(code)) {
      return _handlers[code]!.stream;
    } else {
      return (_handlers[code] = StreamController<String>.broadcast()).stream;
    }
  }

  static Stream<String> bindKeys(List<String> codes) {
    init();
    // ignore: close_sinks
    final controller = StreamController<String>.broadcast();
    for (final key in codes) {
      bindKey(key).listen(controller.add);
    }
    return controller.stream;
  }
}

final Map<String, String> inputSequences = {
  'A': 'up',
  'B': 'down',
  'C': 'right',
  'D': 'left',
  'E': '5',
  'F': 'end',
  'G': '5',
  'H': 'home',
  '1~': 'home',
  '2~': 'insert',
  '3~': 'delete',
  '4~': 'end',
  '5~': 'page up',
  '6~': 'page down',
  '7~': 'home',
  '8~': 'end',
  '[A': 'f1',
  '[B': 'f2',
  '[C': 'f3',
  '[D': 'f4',
  '[E': 'f5',
  '11~': 'f1',
  '12~': 'f2',
  '13~': 'f3',
  '14~': 'f4',
  '15~': 'f5',
  '17~': 'f6',
  '18~': 'f7',
  '19~': 'f8',
  '20~': 'f9',
  '21~': 'f10',
  '23~': 'f11',
  '24~': 'f12',
  '25~': 'f13',
  '26~': 'f14',
  '28~': 'f15',
  '29~': 'f16',
  '31~': 'f17',
  '32~': 'f18',
  '33~': 'f19',
  '34~': 'f20',
  'OA': 'up',
  'OB': 'down',
  'OC': 'right',
  'OD': 'left',
  'OH': 'home',
  'OF': 'end',
  'OP': 'f1',
  'OQ': 'f2',
  'OR': 'f3',
  'OS': 'f4',
  'Oo': '/',
  'Oj': '*',
  'Om': '-',
  'Ok': '+',
  'Z': 'shift tab',
  'On': '.',
  'Oa': 'meta up',
  'Ob': 'meta down',
  'Oc': 'meta right',
  'Od': 'meta left',
  'a': 'shift up',
  'b': 'shift down',
  'c': 'shift right',
  'd': 'shift left',
  r'2$': 'shift insert',
  r'3$': 'shift delete',
  r'5$': 'shift page up',
  r'6$': 'shift page down',
  r'7$': 'shift home',
  r'8$': 'shift end',
  '2^': 'meta insert',
  '3^': 'meta delete',
  '5^': 'meta page up',
  '6^': 'meta page down',
  '7^': 'meta home',
  '8^': 'meta end',
  'Op': '0',
  'Oq': '1',
  'Or': '2',
  'Os': '3',
  'Ot': '4',
  'Ou': '5',
  'Ov': '6',
  'Ow': '7',
  'Ox': '8',
  'Oy': '9',
  '1A': 'up',
  '1B': 'down',
  '1C': 'right',
  '1D': 'left',
  '1E': '5',
  '1F': 'end',
  '1G': '5',
  '1H': 'home',
  '2A': 'shift up',
  '2B': 'shift down',
  '2C': 'shift right',
  '2D': 'shift left',
  '2E': 'shift 5',
  '2F': 'shift end',
  '2G': 'shift 5',
  '2H': 'shift home',
  '3A': 'meta up',
  '3B': 'meta down',
  '3C': 'meta right',
  '3D': 'meta left',
  '3E': 'meta 5',
  '3F': 'meta end',
  '3G': 'meta 5',
  '3H': 'meta home',
  '4A': 'shift meta up',
  '4B': 'shift meta down',
  '4C': 'shift meta right',
  '4D': 'shift meta left',
  '4E': 'shift meta 5',
  '4F': 'shift meta end',
  '4G': 'shift meta 5',
  '4H': 'shift meta home',
  '5A': 'ctrl up',
  '5B': 'ctrl down',
  '5C': 'ctrl right',
  '5D': 'ctrl left',
  '5E': 'ctrl 5',
  '5F': 'ctrl end',
  '5G': 'ctrl 5',
  '5H': 'ctrl home',
  '6A': 'shift ctrl up',
  '6B': 'shift ctrl down',
  '6C': 'shift ctrl right',
  '6D': 'shift ctrl left',
  '6E': 'shift ctrl 5',
  '6F': 'shift ctrl end',
  '6G': 'shift ctrl 5',
  '6H': 'shift ctrl home',
  '7A': 'meta ctrl up',
  '7B': 'meta ctrl down',
  '7C': 'meta ctrl right',
  '7D': 'meta ctrl left',
  '7E': 'meta ctrl 5',
  '7F': 'meta ctrl end',
  '7G': 'meta ctrl 5',
  '7H': 'meta ctrl home',
  '8A': 'shift meta ctrl up',
  '8B': 'shift meta ctrl down',
  '8C': 'shift meta ctrl right',
  '8D': 'shift meta ctrl left',
  '8E': 'shift meta ctrl 5',
  '8F': 'shift meta ctrl end',
  '8G': 'shift meta ctrl 5',
  '8H': 'shift meta ctrl home',
  '1;1A': 'up',
  '1;1B': 'down',
  '1;1C': 'right',
  '1;1D': 'left',
  '1;1E': '5',
  '1;1F': 'end',
  '1;1G': '5',
  '1;1H': 'home',
  '1;2A': 'shift up',
  '1;2B': 'shift down',
  '1;2C': 'shift right',
  '1;2D': 'shift left',
  '1;2E': 'shift 5',
  '1;2F': 'shift end',
  '1;2G': 'shift 5',
  '1;2H': 'shift home',
  '1;3A': 'meta up',
  '1;3B': 'meta down',
  '1;3C': 'meta right',
  '1;3D': 'meta left',
  '1;3E': 'meta 5',
  '1;3F': 'meta end',
  '1;3G': 'meta 5',
  '1;3H': 'meta home',
  '1;4A': 'shift meta up',
  '1;4B': 'shift meta down',
  '1;4C': 'shift meta right',
  '1;4D': 'shift meta left',
  '1;4E': 'shift meta 5',
  '1;4F': 'shift meta end',
  '1;4G': 'shift meta 5',
  '1;4H': 'shift meta home',
  '1;5A': 'ctrl up',
  '1;5B': 'ctrl down',
  '1;5C': 'ctrl right',
  '1;5D': 'ctrl left',
  '1;5E': 'ctrl 5',
  '1;5F': 'ctrl end',
  '1;5G': 'ctrl 5',
  '1;5H': 'ctrl home',
  '1;6A': 'shift ctrl up',
  '1;6B': 'shift ctrl down',
  '1;6C': 'shift ctrl right',
  '1;6D': 'shift ctrl left',
  '1;6E': 'shift ctrl 5',
  '1;6F': 'shift ctrl end',
  '1;6G': 'shift ctrl 5',
  '1;6H': 'shift ctrl home',
  '1;7A': 'meta ctrl up',
  '1;7B': 'meta ctrl down',
  '1;7C': 'meta ctrl right',
  '1;7D': 'meta ctrl left',
  '1;7E': 'meta ctrl 5',
  '1;7F': 'meta ctrl end',
  '1;7G': 'meta ctrl 5',
  '1;7H': 'meta ctrl home',
  '1;8A': 'shift meta ctrl up',
  '1;8B': 'shift meta ctrl down',
  '1;8C': 'shift meta ctrl right',
  '1;8D': 'shift meta ctrl left',
  '1;8E': 'shift meta ctrl 5',
  '1;8F': 'shift meta ctrl end',
  '1;8G': 'shift meta ctrl 5',
  '1;8H': 'shift meta ctrl home',
  'O1P': 'f1',
  'O1Q': 'f2',
  'O1R': 'f3',
  'O1S': 'f4',
  'O2P': 'shift f1',
  'O2Q': 'shift f2',
  'O2R': 'shift f3',
  'O2S': 'shift f4',
  'O3P': 'meta f1',
  'O3Q': 'meta f2',
  'O3R': 'meta f3',
  'O3S': 'meta f4',
  'O4P': 'shift meta f1',
  'O4Q': 'shift meta f2',
  'O4R': 'shift meta f3',
  'O4S': 'shift meta f4',
  'O5P': 'ctrl f1',
  'O5Q': 'ctrl f2',
  'O5R': 'ctrl f3',
  'O5S': 'ctrl f4',
  'O6P': 'shift ctrl f1',
  'O6Q': 'shift ctrl f2',
  'O6R': 'shift ctrl f3',
  'O6S': 'shift ctrl f4',
  'O7P': 'meta ctrl f1',
  'O7Q': 'meta ctrl f2',
  'O7R': 'meta ctrl f3',
  'O7S': 'meta ctrl f4',
  'O8P': 'shift meta ctrl f1',
  'O8Q': 'shift meta ctrl f2',
  'O8R': 'shift meta ctrl f3',
  'O8S': 'shift meta ctrl f4',
  '3;1~': 'delete',
  '5;1~': 'page up',
  '6;1~': 'page down',
  '11;1~': 'f1',
  '12;1~': 'f2',
  '13;1~': 'f3',
  '14;1~': 'f4',
  '15;1~': 'f5',
  '17;1~': 'f6',
  '18;1~': 'f7',
  '19;1~': 'f8',
  '20;1~': 'f9',
  '21;1~': 'f10',
  '23;1~': 'f11',
  '24;1~': 'f12',
  '25;1~': 'f13',
  '26;1~': 'f14',
  '28;1~': 'f15',
  '29;1~': 'f16',
  '31;1~': 'f17',
  '32;1~': 'f18',
  '33;1~': 'f19',
  '34;1~': 'f20',
  '3;2~': 'shift delete',
  '5;2~': 'shift page up',
  '6;2~': 'shift page down',
  '11;2~': 'shift f1',
  '12;2~': 'shift f2',
  '13;2~': 'shift f3',
  '14;2~': 'shift f4',
  '15;2~': 'shift f5',
  '17;2~': 'shift f6',
  '18;2~': 'shift f7',
  '19;2~': 'shift f8',
  '20;2~': 'shift f9',
  '21;2~': 'shift f10',
  '23;2~': 'shift f11',
  '24;2~': 'shift f12',
  '25;2~': 'shift f13',
  '26;2~': 'shift f14',
  '28;2~': 'shift f15',
  '29;2~': 'shift f16',
  '31;2~': 'shift f17',
  '32;2~': 'shift f18',
  '33;2~': 'shift f19',
  '34;2~': 'shift f20',
  '3;3~': 'meta delete',
  '5;3~': 'meta page up',
  '6;3~': 'meta page down',
  '11;3~': 'meta f1',
  '12;3~': 'meta f2',
  '13;3~': 'meta f3',
  '14;3~': 'meta f4',
  '15;3~': 'meta f5',
  '17;3~': 'meta f6',
  '18;3~': 'meta f7',
  '19;3~': 'meta f8',
  '20;3~': 'meta f9',
  '21;3~': 'meta f10',
  '23;3~': 'meta f11',
  '24;3~': 'meta f12',
  '25;3~': 'meta f13',
  '26;3~': 'meta f14',
  '28;3~': 'meta f15',
  '29;3~': 'meta f16',
  '31;3~': 'meta f17',
  '32;3~': 'meta f18',
  '33;3~': 'meta f19',
  '34;3~': 'meta f20',
  '3;4~': 'shift meta delete',
  '5;4~': 'shift meta page up',
  '6;4~': 'shift meta page down',
  '11;4~': 'shift meta f1',
  '12;4~': 'shift meta f2',
  '13;4~': 'shift meta f3',
  '14;4~': 'shift meta f4',
  '15;4~': 'shift meta f5',
  '17;4~': 'shift meta f6',
  '18;4~': 'shift meta f7',
  '19;4~': 'shift meta f8',
  '20;4~': 'shift meta f9',
  '21;4~': 'shift meta f10',
  '23;4~': 'shift meta f11',
  '24;4~': 'shift meta f12',
  '25;4~': 'shift meta f13',
  '26;4~': 'shift meta f14',
  '28;4~': 'shift meta f15',
  '29;4~': 'shift meta f16',
  '31;4~': 'shift meta f17',
  '32;4~': 'shift meta f18',
  '33;4~': 'shift meta f19',
  '34;4~': 'shift meta f20',
  '3;5~': 'ctrl delete',
  '5;5~': 'ctrl page up',
  '6;5~': 'ctrl page down',
  '11;5~': 'ctrl f1',
  '12;5~': 'ctrl f2',
  '13;5~': 'ctrl f3',
  '14;5~': 'ctrl f4',
  '15;5~': 'ctrl f5',
  '17;5~': 'ctrl f6',
  '18;5~': 'ctrl f7',
  '19;5~': 'ctrl f8',
  '20;5~': 'ctrl f9',
  '21;5~': 'ctrl f10',
  '23;5~': 'ctrl f11',
  '24;5~': 'ctrl f12',
  '25;5~': 'ctrl f13',
  '26;5~': 'ctrl f14',
  '28;5~': 'ctrl f15',
  '29;5~': 'ctrl f16',
  '31;5~': 'ctrl f17',
  '32;5~': 'ctrl f18',
  '33;5~': 'ctrl f19',
  '34;5~': 'ctrl f20',
  '3;6~': 'shift ctrl delete',
  '5;6~': 'shift ctrl page up',
  '6;6~': 'shift ctrl page down',
  '11;6~': 'shift ctrl f1',
  '12;6~': 'shift ctrl f2',
  '13;6~': 'shift ctrl f3',
  '14;6~': 'shift ctrl f4',
  '15;6~': 'shift ctrl f5',
  '17;6~': 'shift ctrl f6',
  '18;6~': 'shift ctrl f7',
  '19;6~': 'shift ctrl f8',
  '20;6~': 'shift ctrl f9',
  '21;6~': 'shift ctrl f10',
  '23;6~': 'shift ctrl f11',
  '24;6~': 'shift ctrl f12',
  '25;6~': 'shift ctrl f13',
  '26;6~': 'shift ctrl f14',
  '28;6~': 'shift ctrl f15',
  '29;6~': 'shift ctrl f16',
  '31;6~': 'shift ctrl f17',
  '32;6~': 'shift ctrl f18',
  '33;6~': 'shift ctrl f19',
  '34;6~': 'shift ctrl f20',
  '3;7~': 'meta ctrl delete',
  '5;7~': 'meta ctrl page up',
  '6;7~': 'meta ctrl page down',
  '11;7~': 'meta ctrl f1',
  '12;7~': 'meta ctrl f2',
  '13;7~': 'meta ctrl f3',
  '14;7~': 'meta ctrl f4',
  '15;7~': 'meta ctrl f5',
  '17;7~': 'meta ctrl f6',
  '18;7~': 'meta ctrl f7',
  '19;7~': 'meta ctrl f8',
  '20;7~': 'meta ctrl f9',
  '21;7~': 'meta ctrl f10',
  '23;7~': 'meta ctrl f11',
  '24;7~': 'meta ctrl f12',
  '25;7~': 'meta ctrl f13',
  '26;7~': 'meta ctrl f14',
  '28;7~': 'meta ctrl f15',
  '29;7~': 'meta ctrl f16',
  '31;7~': 'meta ctrl f17',
  '32;7~': 'meta ctrl f18',
  '33;7~': 'meta ctrl f19',
  '34;7~': 'meta ctrl f20',
  '3;8~': 'shift meta ctrl delete',
  '5;8~': 'shift meta ctrl page up',
  '6;8~': 'shift meta ctrl page down',
  '11;8~': 'shift meta ctrl f1',
  '12;8~': 'shift meta ctrl f2',
  '13;8~': 'shift meta ctrl f3',
  '14;8~': 'shift meta ctrl f4',
  '15;8~': 'shift meta ctrl f5',
  '17;8~': 'shift meta ctrl f6',
  '18;8~': 'shift meta ctrl f7',
  '19;8~': 'shift meta ctrl f8',
  '20;8~': 'shift meta ctrl f9',
  '21;8~': 'shift meta ctrl f10',
  '23;8~': 'shift meta ctrl f11',
  '24;8~': 'shift meta ctrl f12',
  '25;8~': 'shift meta ctrl f13',
  '26;8~': 'shift meta ctrl f14',
  '28;8~': 'shift meta ctrl f15',
  '29;8~': 'shift meta ctrl f16',
  '31;8~': 'shift meta ctrl f17',
  '32;8~': 'shift meta ctrl f18',
  '33;8~': 'shift meta ctrl f19',
  '34;8~': 'shift meta ctrl f20',
  'M': 'mouse',
  '0n': 'status ok'
};

abstract class DCKeyCode {
  static const String UP = '${DCConsole.ANSI_ESCAPE}A';
  static const String DOWN = '${DCConsole.ANSI_ESCAPE}B';
  static const String RIGHT = '${DCConsole.ANSI_ESCAPE}C';
  static const String LEFT = '${DCConsole.ANSI_ESCAPE}D';
  static const String HOME = '${DCConsole.ANSI_ESCAPE}H';
  static const String END = '${DCConsole.ANSI_ESCAPE}F';
  static const String F1 = '${DCConsole.ANSI_ESCAPE}M';
  static const String F2 = '${DCConsole.ANSI_ESCAPE}N';
  static const String F3 = '${DCConsole.ANSI_ESCAPE}O';
  static const String F4 = '${DCConsole.ANSI_ESCAPE}P';
  static const String F5 = '${DCConsole.ANSI_ESCAPE}Q';
  static const String F6 = '${DCConsole.ANSI_ESCAPE}R';
  static const String F7 = '${DCConsole.ANSI_ESCAPE}S';
  static const String F8 = '${DCConsole.ANSI_ESCAPE}T';
  static const String F9 = '${DCConsole.ANSI_ESCAPE}U';
  static const String F10 = '${DCConsole.ANSI_ESCAPE}V';
  static const String F11 = '${DCConsole.ANSI_ESCAPE}W';
  static const String F12 = '${DCConsole.ANSI_ESCAPE}X';
  static const String INS = '${DCConsole.ANSI_ESCAPE}2~';
  static const String DEL = '${DCConsole.ANSI_ESCAPE}3~';
  static const String PAGE_UP = '${DCConsole.ANSI_ESCAPE}5~';
  static const String PAGE_DOWN = '${DCConsole.ANSI_ESCAPE}6~';
  static const String SPACE = ' ';
  static const String ESC = '\u001b';
  static const String ENTER = '\u000a';
}
