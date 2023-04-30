import 'package:athena_migrate/athena_migrate.dart';

abstract class ConsoleConfig {
  static const migrationDestination = 'database/migrations';
  static const stubsDirectory = 'templates/stubs';
}

void main(List<String> args) {
  var command = AthenaMigrateComands();
  command.run(args);
}
