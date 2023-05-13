import 'dart:convert';
import 'dart:io' as io;

/// Console transform Colors
enum TokensColor {
  /// balck color
  black('30'),

  /// red color
  red('31'),

  /// green color
  green('32'),

  /// yellow color
  yellow('33'),

  /// blue color
  blue('34'),

  /// magenta color
  magenta('35'),

  /// cyan color
  cyan('36'),

  /// white color
  white('37');
  /// create a color with its code
  const TokensColor(this.code);

  /// color code representation
  final String code;

  /// Transform a string to a printable string
  String printable(String value) {
    return '\x1B[${code}m$value\x1B[0m';
  }
}

/// Print messages in the console
class Print {
  static void _print(Object? object, TokensColor color) {
    print(color.printable('$object'));
  }

  /// Print a red message in the console
  static void red(Object? object) {
    _print(object, TokensColor.red);
  }

  /// Print a yellow message in the console
  static void yellow(Object? object) {
    _print(object, TokensColor.yellow);
  }

  /// Print a green message in the console
  static void green(Object? object) {
    _print(object, TokensColor.green);
  }

  /// Print a blue message in the console
  static void blue(Object? object) {
    _print(object, TokensColor.blue);
  }
}

/// Find types
enum Find {
  /// find files
  file,

  /// find directories
  directory,

  /// find links
  link
}

/// Console utils
class ConsoleService {
  ConsoleService._();

  /// shared instance
  static ConsoleService instance = ConsoleService._();

  /// Confirm question on command line
  bool confirm(String question, {bool defaultValue = false}) {
    io.stdout.write('$question (y/n): ');
    final response = io.stdin.readLineSync();
    if (response == null || response.isEmpty) return defaultValue;
    return response == 'y' || response == 'Y';
  }

  /// Ask question on command line
  String ask(String question,
      {String? defaultValue, bool? required, dynamic validator}) {
    io.stdout
        .write('$question${defaultValue == null ? '' : ' ($defaultValue)'}: ');
    final response = io.stdin.readLineSync();
    if (response == null || response.isEmpty) {
      if (defaultValue == null) {
        if (required == true) {
          Print.red('Required');
          return ask(question,
              defaultValue: defaultValue,
              required: required,
              validator: validator);
        }
        return '';
      }
      return defaultValue;
    }
    if (validator != null && !validator.hasMatch(response)) {
      Print.red('Invalid value');
      return ask(question,
          defaultValue: defaultValue, required: required, validator: validator);
    }
    return response;
  }

  /// show a selectable menu on command line
  T menu<T>(
      {required String prompt,
      required List<T> options,
      required String Function(T) format}) {
    final optionsString = options.map((e) => format(e)).toList();
    final optionsWithIndex =
        optionsString.asMap().map((key, value) => MapEntry(key + 1, value));
    final optionsWithIndexString =
        optionsWithIndex.map((key, value) => MapEntry('$key - $value', key));
    final optionsStringWithNewLine = optionsWithIndexString.values.join('\n');
    final question = '$prompt\n$optionsStringWithNewLine\n';
    final response = ask(question);
    if (response.isEmpty) {
      Print.red('Invalid option');
      return menu(prompt: prompt, options: options, format: format);
    }
    final index = int.tryParse(response);
    if (index == null || !optionsWithIndex.containsKey(index)) {
      Print.red('Invalid option');
      return menu(prompt: prompt, options: options, format: format);
    }
    return options[index - 1];
  }

  /// Find files or directories
  List<String> find(String pattern,
      {List<Find> types = const [Find.file],
      bool recursive = true,
      String workingDirectory = '.'}) {
    final dir = io.Directory(workingDirectory);
    if (!dir.existsSync()) {
      return <String>[];
    }

    final entities = dir.listSync().where((e) {
      if (types.contains(Find.directory) && e is io.Directory) {
        return true;
      }
      if (types.contains(Find.file) && e is io.File) {
        return true;
      }
      if (types.contains(Find.link) && e is io.Link) {
        return true;
      }
      return false;
    }).where((element) {
      final source = pattern
          .replaceAll('/', r'\\')
          .replaceAll('.', r'\.')
          .replaceAll('*', '.*')
          .replaceAll('**', '.*');
      try {
        return RegExp(source).hasMatch(element.path);
      } catch (e) {
        return false;
      }
    });
    for (final element in entities) {
      print(element.path);
    }

    return entities.map((e) => e.path).toList();
  }
}

/// service to manage io operations
class IOService {
  IOService._();

  /// shared instance
  static IOService instance = IOService._();

  /// exit the program
  Never exit(int code) {
    return io.exit(code);
  }
}

/// service to run process
class ProcessService {
  ProcessService._();

  /// shared instance
  static ProcessService instance = ProcessService._();

  /// run a process
  Future<int> run(String executable,
      {List<String> arguments = const <String>[]}) {
    return io.Process.start(executable, arguments, runInShell: true)
        .then((value) {
      value.stdout.transform(utf8.decoder).listen(print);
      value.stderr.transform(utf8.decoder).listen(print);
      return value.exitCode;
    });
  }
}
