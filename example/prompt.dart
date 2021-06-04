
import 'package:console/prompt.dart';

// Shows input fields for regular and secret text entry.
Future<void> main() async {
  final username = await readInput('Username: ');
  final password = await readInput('Password: ', secret: true);
  print('$username -> $password');
}
