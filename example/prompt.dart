
import 'package:console/prompt.dart';

Future<void> main() async {
  final username = await readInput('Username: ');
  final password = await readInput('Password: ', secret: true);
  print('$username -> $password');
}
