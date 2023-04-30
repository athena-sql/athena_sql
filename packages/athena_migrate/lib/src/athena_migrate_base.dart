import 'dart:io';

import 'package:athena_migrate/src/commands/create_migration.dart';
import 'package:athena_migrate/src/commands/migrate_local.dart';
import 'package:athena_migrate/src/executable.dart';
import 'package:dcli/dcli.dart';
import 'package:collection/collection.dart';

import 'utils/config.dart';

class AthenaMigrateComands {
  final List<ExecutableComand> execs = [];
  Future<void> run(List<String> args) async {
    final config = ReadConfig().run();
    if (config == null) exit(1);

    final List<ExecutableComand> executables = [
      ...execs,
      CreateMigrationCommand(config),
      LocalMigrationCommand(config, command: 'up'),
      LocalMigrationCommand(config, command: 'down'),
      LocalMigrationCommand(config, command: 'redo'),
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
        print(red('Unknown command: $key'));
        print('Available commands are:');
        for (var ex in execs) {
          print('  $ex.name - $ex.description');
        }
        exit(1);
      }
      await executable.run(parsed.command);
    } else {
      final selected = menu(
          prompt: 'select an option',
          options: executables,
          format: (ex) => '${ex.command} - ${ex.description}');
      selected.run(parsed.command);
    }
  }
}
