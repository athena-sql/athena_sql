import 'dart:io';

// import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:athena_migrate/src/commands/status.dart';
import 'package:athena_migrate/src/executable.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as path;
import 'package:collection/collection.dart';

abstract class ConsoleConfig {
  static const migrationDestination = 'database/migrations';
  static const stubsDirectory = 'templates/stubs';
}

const migrationFile = '''
import 'package:athena_sql/athena_sql.dart';

class Migration_{{name}}_{{date}} extends AthenaMigration {
  Migration() : super({{name}},{{date}});
  @override
  Future<void> up(AthenaSQL<AthenaDatabaseDriver> db) {
    // add the migration code here
  }
  @override
  Future<void> down(AthenaSQL<AthenaDatabaseDriver> db) {
    // add the migration code here
  }
}
''';

var defaultListContents = '''
import 'package:athena_sql/athena_sql.dart';

import 'index.dart';

final List<Migration> migrations = [
];

''';

const drivers = <String, String>{
  'postgresql': 'MySQL',
};

class MigrationNew {
  final String name;
  final String date;
  final String driver;

  String get contents => migrationFile
      .replaceAll('{{date}}', date)
      .replaceAll('{{driver}}', driver)
      .replaceAll('{{name}}', name);

  String get fileName => '${date}_$name.dart';
  String get className => 'Migration_${name}_$date';

  MigrationNew(this.name, this.date, this.driver);

  File generate(String destinationFile) => File(destinationFile)
    ..createSync(recursive: true)
    ..writeAsStringSync(contents);

  void register(String destinationDir) {
    registerMainFile(destinationDir);
    registerInIndexFile(destinationDir);
    registerInListFile(destinationDir);
  }

  void registerMainFile(String destinationDir) {
      File(path.join(destinationDir, fileName))
        ..createSync(recursive: true)
        ..writeAsStringSync(contents);
  }
  void registerInIndexFile(String destinationDir) {
    var indexFile = File(path.join(destinationDir, 'index.dart'));
    var indexContents =
        indexFile.existsSync() ? indexFile.readAsStringSync() : '// end\n';
    var migrationExport = "export '${path.basename(fileName)}';\n// end";

    indexContents = indexContents.replaceAll('// end', migrationExport);
    indexFile
      ..createSync()
      ..writeAsStringSync(indexContents);
  }

  void registerInListFile(String destinationDir) {
    var listFile = File(path.join(destinationDir, 'list.dart'));

    var listContents = listFile.existsSync()
        ? listFile.readAsStringSync()
        : defaultListContents;
    var migrationInstance = " $className,\n];";

    listContents = listContents.replaceAll('];', migrationInstance);
    listFile
      ..createSync()
      ..writeAsStringSync(listContents);
  }
}

class CreateMigrationCommand extends ExecutableComand {
  final AthenaConfig config;

  String getDateNewMigration() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy_MM_dd_HHmmss');
    return formatter.format(now);
  }

  CreateMigrationCommand(this.config): super('create', 'Creates a migration file');

  MigrationNew _loadTemplate(String migrationName) {
    final date = getDateNewMigration();

    return MigrationNew(migrationName.snakeCase, date, config.driver);
  }

  @override
  Future<int> run(ArgResults? args) async {
    // var logging = silent ? null : progress('Creating migration');
    var migrationName = args?.arguments.join(' ');
    if (migrationName == null) {
      print(yellow('Migration name is required'));
      var name = ask('name:', required: true, validator: Ask.alpha);
      migrationName = name;
      return 1;
    }
    print('Creating migration');
    final migration = _loadTemplate(migrationName);
    migration.register(config.migrationsPath);

    print('Migration created: ${migration.fileName}');

    return 0;
  }

}


extension StringExtension on String {
  String snakeCasetoSentenceCase() {
    return "${this[0].toUpperCase()}${this.substring(1)}"
        .replaceAll(RegExp(r'(_|-)+'), ' ');
  }
}

// convert any string into snake_case
extension StringExtension2 on String {
  String get snakeCase  {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => '${match.group(0)}')
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'(_|-)+'), '_');
  }
}