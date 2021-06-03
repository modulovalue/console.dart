import 'dart:async';
import 'dart:io';

import 'base.dart';
import 'color.dart';

abstract class VariableStyle {
  static const _SingleBracketVariableStyle SINGLE_BRACKET = _SingleBracketVariableStyle();
  static const _DoubleBracketVariableStyle DOUBLE_BRACKET = _DoubleBracketVariableStyle();
  static const _BashBracketVariableStyle BASH_BRACKET = _BashBracketVariableStyle();
  static VariableStyle DEFAULT = SINGLE_BRACKET;

  const VariableStyle();

  Set<String> findVariables(String input);

  String replace(String input, String variable, String value);

  /// Calls [action] in a [Zone] that has it's format
  /// variable style set to [style].
  static void withStyle(VariableStyle style, void Function() action) {
    runZoned(() {
      action();
    }, zoneValues: {'console.format.variable_style': style});
  }
}

class _DoubleBracketVariableStyle extends VariableStyle {
  static final RegExp _REGEX = RegExp(r'\{\{(.+?)\}\}');

  const _DoubleBracketVariableStyle();

  @override
  Set<String> findVariables(String input) {
    final matches = _REGEX.allMatches(input);
    final allKeys = <String>{};
    for (final match in matches) {
      final key = match.group(1);
      if (key != null && !allKeys.contains(key)) {
        allKeys.add(key);
      }
    }
    return allKeys;
  }

  @override
  String replace(String input, String variable, String value) {
    return input.replaceAll('{{$variable}}', value);
  }
}

class _BashBracketVariableStyle extends VariableStyle {
  static final RegExp _REGEX = RegExp(r'\$\{(.+?)\}');

  const _BashBracketVariableStyle();

  @override
  Set<String> findVariables(String input) {
    final matches = _REGEX.allMatches(input);
    final allKeys = <String>{};
    for (final match in matches) {
      final key = match.group(1);
      if (key != null && !allKeys.contains(key)) {
        allKeys.add(key);
      }
    }
    return allKeys;
  }

  @override
  String replace(String input, String variable, String value) {
    return input.replaceAll('\${$variable}', value);
  }
}

class _SingleBracketVariableStyle extends VariableStyle {
  static final RegExp _REGEX = RegExp(r'\{(.+?)\}');

  const _SingleBracketVariableStyle();

  @override
  Set<String> findVariables(String input) {
    final matches = _REGEX.allMatches(input);
    final allKeys = <String>{};
    for (final match in matches) {
      final key = match.group(1);
      if (key != null && !allKeys.contains(key)) {
        allKeys.add(key);
      }
    }
    return allKeys;
  }

  @override
  String replace(String input, String variable, String value) {
    return input.replaceAll('{$variable}', value);
  }
}

typedef VariableResolver = String Function(String variable);

String format(String input, {List<String>? args, Map<String, String>? replace, VariableStyle? style, VariableResolver? resolver}) {
  style ??= VariableStyle.DEFAULT;
  if (Zone.current['console.format.variable_style'] != null) {
    // ignore: parameter_assignments
    style = Zone.current['console.format.variable_style'] as VariableStyle?;
  }
  var out = input;
  final allKeys = style!.findVariables(input);
  for (final id in allKeys) {
    if (args != null) {
      try {
        final index = int.parse(id);
        if (index < 0 || index > args.length - 1) {
          throw RangeError.range(index, 0, args.length - 1);
        }
        out = style.replace(out, '$index', args[index]);
        continue;
        // ignore: empty_catches
      } on FormatException {}
    }
    if (replace != null && replace.containsKey(id)) {
      out = style.replace(out, id, replace[id]!);
      continue;
    }
    if (id.startsWith('@') || id.startsWith('color.')) {
      final color = id.startsWith('@') ? id.substring(1) : id.substring(6);
      if (color.isEmpty) {
        throw Exception('color directive requires an argument');
      }
      if (COLORS.containsKey(color)) {
        out = style.replace(out, '$id', COLORS[color].toString());
        continue;
      }
      if (color == 'normal' || color == 'end') {
        out = style.replace(out, id, '${Console.ANSI_ESCAPE}0m');
        continue;
      }
    }
    if (id.startsWith('env.')) {
      final envVariable = id.substring(4);
      if (envVariable.isEmpty) {
        throw Exception('Unknown Key: $id');
      }
      var value = Platform.environment[envVariable];
      value ??= '';
      out = style.replace(out, id, value);
      continue;
    }
    if (id.startsWith('platform.')) {
      final variable = id.substring(9);
      if (variable.isEmpty) {
        throw Exception('Unknown Key: $id');
      }
      final value = _resolvePlatformVariable(variable);
      out = style.replace(out, id, value);
      continue;
    }
    if (resolver != null) {
      final value = resolver(id);
      out = style.replace(out, id, value);
    } else {
      throw Exception('Unknown Key: $id');
    }
  }
  return out;
}

String _resolvePlatformVariable(String name) {
  switch (name) {
    case 'hostname':
      return Platform.localHostname;
    case 'executable':
      return Platform.executable;
    case 'os':
      return Platform.operatingSystem;
    case 'version':
      return Platform.version;
    case 'script':
      return Platform.script.toString();
    default:
      throw Exception('Unsupported Platform Variable: $name');
  }
}
