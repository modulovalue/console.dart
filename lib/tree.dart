// import 'base.dart';
// import 'icons.dart';
//
// /// Prints a tree. This is ported from the NPM code (the dependency tree)
// void printTree(dynamic input, {String prefix = '', Map? opts}) {
//   Console.write(createTree(input, prefix: prefix, opts: opts));
// }
//
// /// Creates a Tree (this is like the npm dependency tree)
// String createTree(Map<String, String> input, {String prefix = '', Map? opts}) {
//   var label = input.containsKey('label') ? input['label'] : '';
//   // var nodes = input.containsKey('nodes') ? input['nodes'] : <String>[];
//   var lines = label.split('\n');
//   var splitter = '\n' + prefix + (nodes.isNotEmpty ? Icon.PIPE_VERTICAL : ' ') + ' ';
//   return prefix +
//       lines.join(splitter) +
//       '\n' +
//       nodes.map(
//         (node) {
//           var last = nodes.last == node;
//           var more = node is Map && node.containsKey('nodes') && node['nodes'] is List && node['nodes'].isNotEmpty;
//           var prefix_ = prefix + (last ? ' ' : Icon.PIPE_VERTICAL) + ' ';
//           return prefix +
//               (last ? Icon.PIPE_LEFT_HALF_VERTICAL : Icon.PIPE_LEFT_VERTICAL) +
//               Icon.PIPE_HORIZONTAL +
//               (more ? Icon.PIPE_BOTH : Icon.PIPE_HORIZONTAL) +
//               ' ' +
//               createTree(node, prefix: prefix_, opts: opts).substring(prefix.length + 2);
//         },
//       ).join('');
// }
