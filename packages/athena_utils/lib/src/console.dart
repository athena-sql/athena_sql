import 'dart:io';

enum TokensColor {
  black("30"),
  red("31"),
  green("32"),
  yellow("33"),
  blue("34"),
  magenta("35"),
  cyan("36"),
  white("37");

  final String code;
  const TokensColor(this.code);

  String printable(String value) {
    return '\x1B[${code}m$value\x1B[0m';
  }
}

class Print {
  static void _print(Object? object, TokensColor color) {
    print(color.printable('$object'));
  }
  static void red(Object? object) {
    _print(object, TokensColor.red);
  }

  static void yellow(Object? object) {
    _print(object, TokensColor.yellow);
  }
}

enum Find { file, directory, link }

class Console {
  Console._();
  static bool confirm(String question, {bool defaultValue = false}) {
    stdout.write('$question (y/n): ');
    final response = stdin.readLineSync();
    if (response == null || response.isEmpty) return defaultValue;
    return response == 'y' || response == 'Y';
  }

  static String ask(String question,
      {String? defaultValue, bool? required, validator}) {
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
