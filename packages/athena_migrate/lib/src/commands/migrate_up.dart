import 'dart:io';

import 'package:args/src/arg_results.dart';
import 'package:athena_migrate/src/commands/status.dart';
import 'package:dcli/dcli.dart';
import 'package:path/path.dart' as path;
import 'package:collection/collection.dart';

import '../executable.dart';

const migrateCommand = '''
import 'package:athena_sql/athena_sql.dart';
import '../athena_migrate.dart';

void main(List<String> args) {
  athenaMigrate(args);  
}
''';

class LocalMigrationCommand extends ExecutableComand {
  final AthenaConfig config;
  const LocalMigrationCommand(this.config, { required String command }) : super(command, 'Create a new migration');


  File get migrationFile => File(path.join('bin', '${config.migrationProgram}.dart'));

  void createFile() {

    final listOfMigrations = path.join('..', config.migrationsPath, 'index.dart');
    final finalContent = migrateCommand.replaceAll('{{path}}',listOfMigrations);
    migrationFile
      ..createSync(recursive: true)
      ..writeAsStringSync(finalContent);
  }
  bool existsFile() {
    return migrationFile.existsSync();
  }
  @override
  Future<int> run(ArgResults? args) async {
    if(args == null) exit(1);
    final program = config.migrationProgram;
    if(!existsFile()) {
      createFile();
    }
    final List<String> comands = [args.name, ...args.rest].whereNotNull().toList();
    'dart run :$program $comands'.run;
    return 0;
  }
}
