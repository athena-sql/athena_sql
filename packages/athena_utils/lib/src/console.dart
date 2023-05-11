import 'dart:io';

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
class Console {
  Console._();

  /// Confirm question on command line
  static bool confirm(String question, {bool defaultValue = false}) {
    stdout.write('$question (y/n): ');
    final response = stdin.readLineSync();
    if (response == null || response.isEmpty) return defaultValue;
    return response == 'y' || response == 'Y';
  }

  /// Ask question on command line
  static String ask(String question,
      {String? defaultValue, bool? required, dynamic validator}) {
    stdout
        .write('$question${defaultValue == null ? '' : ' ($defaultValue)'}: ');
    final response = stdin.readLineSync();
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
  static T menu<T>(
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
  static List<String> find(String pattern,
      {List<Find> types = const [Find.file],
      bool recursive = true,
      String workingDirectory = '.'}) {
    final dir = Directory(workingDirectory);
    if (!dir.existsSync()) {
      return <String>[];
    }

    final entities = dir.listSync().where((e) {
      if (types.contains(Find.directory) && e is Directory) {
        return true;
      }
      if (types.contains(Find.file) && e is File) {
        return true;
      }
      if (types.contains(Find.link) && e is Link) {
        return true;
      }
      return false;
    }).where((element) => RegExp(pattern).hasMatch(element.path));

    return entities.map((e) => e.path).toList();
  }
}
