import 'dart:io';

DCClipboard? getClipboard() {
  if (Platform.isMacOS) return DCOSXClipboard();
  if (Platform.isLinux && File('/usr/bin/xclip').existsSync()) return DCXClipboard();
  return null;
}

abstract class DCClipboard {
  String getContent();

  void setContent(String content);
}

class DCOSXClipboard implements DCClipboard {
  @override
  String getContent() {
    final result = Process.runSync('/usr/bin/pbpaste', []);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/pbpaste', []).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}

class DCXClipboard implements DCClipboard {
  @override
  String getContent() {
    final result = Process.runSync('/usr/bin/xclip', ['-selection', 'clipboard', '-o']);
    if (result.exitCode != 0) {
      throw Exception('Failed to get clipboard content.');
    }
    return result.stdout.toString();
  }

  @override
  void setContent(String content) {
    Process.start('/usr/bin/xclip', ['-selection', 'clipboard']).then((process) {
      process.stdin.write(content);
      process.stdin.close();
    });
  }
}
