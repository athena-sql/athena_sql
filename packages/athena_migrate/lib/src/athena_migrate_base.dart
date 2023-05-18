import 'dart:io';

import 'package:athena_migrate/src/commands/create_migration.dart';
import 'package:athena_migrate/src/commands/migrate_local.dart';
import 'package:athena_migrate/src/executable.dart';
import 'package:athena_utils/athena_utils.dart';
import 'package:args/args.dart';
import 'package:collection/collection.dart';

class AthenaMigrateComands {
  ConsoleService console;
  AthenaMigrateComands({ConsoleService? console})
      : console = console ?? ConsoleService.instance;
  final List<ExecutableComand> execs = [];
  Future<void> run(List<String> args) async {
    final config = ReadAthenaConfig().run();
    if (config == null) exit(1);

    final List<ExecutableComand> executables = [
      ...execs,
      CreateMigrationCommand(config),
      LocalMigrationCommand(config, command: 'up'),
      LocalMigrationCommand(config, command: 'down'),
      LocalMigrationCommand(config, command: 'all'),
      LocalMigrationCommand(config, command: 'reset'),
      LocalMigrationCommand(config, command: 'redo'),
      LocalMigrationCommand(config, command: 'refresh'),
      LocalMigrationCommand(config, command: 'status'),
      LocalMigrationCommand(config, command: 'version'),
    ];

    var parser = ArgParser();
    parser.addFlag('verbose', abbr: 'v', defaultsTo: false, negatable: false);
    for (var element in executables) {
      parser.addCommand(element.command);
    }

    var parsed = parser.parse(args);

    if (args.isNotEmpty) {
      final key = args[0];
      final executable =
          executables.firstWhereOrNull((element) => element.command == key);
      if (executable == null) {
        Print.red('Unknown command: $key');
        print('Available commands are:');
        for (var ex in execs) {
          print('  $ex.name - $ex.description');
        }
        exit(1);
      }
      await executable.run(parsed.command);
    } else {
      final selected = console.menu(
          prompt: 'select an option',
          options: executables,
          format: (ex) => '${ex.command} - ${ex.description}');
      selected.run(parsed.command);
    }
  }
}
