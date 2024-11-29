import 'package:args/args.dart';
import 'package:athena_utils/athena_utils.dart';
import 'package:path/path.dart' as path;

import '../executable.dart';

const migrateCommand = '''
import 'dart:io';

import 'package:{{athenaDriver}}/{{athenaDriver}}.dart';

{{imports}}

final List<AthenaMigration> migrations = [
{{migrations}}
];

void main(List<String> args) async {
  final config = ReadAthenaConfig().getConfig();
  if (config.connection.isEmpty) {
    print('Please add a connection in the config file');
    exit(1);
    return;
  }
  final athenaSql = await {{athenaInstance}};
  await athenaSql.migrate(migrations, args);
  exit(0);
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
  FileService fs;
  ProcessService ps = ProcessService.instance;
  IOService io;
  ConsoleService console;

  LocalMigrationCommand(this.config,
      {required String command,
      FileService? fs,
      IOService? io,
      ProcessService? ps,
      ConsoleService? console})
      : fs = fs ?? FileService.instance,
        io = io ?? IOService.instance,
        ps = ps ?? ProcessService.instance,
        console = console ?? ConsoleService.instance,
        super(command, 'Create a new migration');

  String get migratePath => path.join('.dart_tool', 'athena_migrate');
  String get migrationFile => path.join(migratePath, 'migrate.dart');

  List<MigrationClasses> getMigrations() {
    final fiels = console.find(r'*.dart',
        types: [Find.file], workingDirectory: config.migrationsPath);

    final migrations = fiels
        .toList()
        .map((e) {
          final content = fs.read(e);

          final regex = RegExp(r'class\s+(\w+)\s+extends AthenaMigration {');
          final match = regex.firstMatch(content);

          if (match != null) {
            final className = match.group(1);
            return MigrationClasses(e, className!);
          } else {
            final pathNoFound = path.relative(e, from: migratePath);
            Print.yellow('No migration found for $pathNoFound');
            return null;
          }
        })
        .nonNulls
        .toList();
    return migrations;
  }

  void createFile() {
    final migrations = getMigrations();

    final imports =
        migrations.map((e) => e.getImport(from: migratePath)).join('\n');

    final migrationClasses =
        migrations.map((e) => '  ${e.classFound}()').join(',\n');

    final configDriver = config.driver.toDriverConfig();
    final finalContent = migrateCommand
        .replaceAll('{{imports}}', imports)
        .replaceAll('{{migrations}}', migrationClasses)
        .replaceAll('{{athenaDriver}}', configDriver.importPackage)
        .replaceAll('{{athenaInstance}}', configDriver.getConstructor());
    fs.writeOn(migrationFile, finalContent);
  }

  bool existsFile() {
    return fs.exists(migrationFile);
  }

  @override
  Future<int> run(ArgResults? args) async {
    if (args == null) io.exit(1);
    createFile();
    final path = migrationFile;
    final List<String> comands = [args.name, ...args.rest].nonNulls.toList();
    final proccess = ps.run(
      'dart',
      arguments: [
        'run',
        path,
        ...comands,
      ],
    );
    return proccess;
  }
}
