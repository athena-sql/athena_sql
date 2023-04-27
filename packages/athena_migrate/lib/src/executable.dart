import 'package:dcli/dcli.dart';

abstract class Executable {
  Future<int> run(ArgResults? args);
  const Executable();
}

abstract class ExecutableComand extends Executable {
  final String command;
  final String description;

  const ExecutableComand(this.command, this.description);
}
