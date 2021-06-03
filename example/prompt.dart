
import 'package:console/prompt.dart';

void main() async {
  var username = await readInput('Username: ');
  var password = await readInput('Password: ', secret: true);
  print('${username} -> ${password}');
}
