import 'dart:io';

import 'package:athena_migrate/src/utils/config.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as path;
import 'package:collection/collection.dart';

import '../executable.dart';

const migrateCommand = '''
import 'package:athena_sql/athena_sql.dart';
{{imports}}

final migrations = [
{{migrations}}
];

void main(List<String> args) {
  print('Running migrations...');
}
''';

class MigrationClasses {
  final String filePath;
  final String classFound;
  MigrationClasses(this.filePath, this.classFound);

  String getImport({required String from}) {
    final relativePath = path.relative(filePath, from: from);
    return "import '${path.normalize(relativePath)}';";
  }
}

class LocalMigrationCommand extends ExecutableComand {
  final AthenaConfig config;
  const LocalMigrationCommand(this.config, {required String command})
      : super(command, 'Create a new migration');

  String get migratePath => path.join('.dart_tool', 'athena_migrate');
  File get migrationFile => File(path.join(migratePath, 'migrate.dart'));

  List<MigrationClasses> getMigrations() {
    final fiels = find(r'*.dart',
        types: [Find.file], workingDirectory: config.migrationsPath);

    final migrations = fiels
        .toList()
        .map((e) {
          final content = File(e).readAsStringSync();

          final regex = RegExp(r'class\s+(\w+)\s+extends AthenaMigration {');
          final match = regex.firstMatch(content);

          if (match != null) {
            final className = match.group(1);
            return MigrationClasses(e, className!);
          } else {
            final pathNoFound = path.relative(e, from: migratePath);
            print(yellow('No migration found for $pathNoFound'));
            return null;
          }
        })
        .whereNotNull()
        .toList();
    return migrations;
  }

  void createFile() {
    final migrations = getMigrations();

    final imports =
        migrations.map((e) => e.getImport(from: migratePath)).join('\n');

    final migrationClasses =
        migrations.map((e) => '  ${e.classFound}()').join(',\n');

    final finalContent = migrateCommand
        .replaceAll('{{imports}}', imports)
        .replaceAll('{{migrations}}', migrationClasses);
    migrationFile
      ..createSync(recursive: true)
      ..writeAsStringSync(finalContent);
  }

  bool existsFile() {
    return migrationFile.existsSync();
  }

  @override
  Future<int> run(ArgResults? args) async {
    if (args == null) exit(1);
    createFile();
    final path = migrationFile.path;
    final List<String> comands =
        [args.name, ...args.rest].whereNotNull().toList();
    'dart run $path $comands'.run;
    return 0;
  }
}
