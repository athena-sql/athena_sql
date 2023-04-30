import 'dart:io';

import 'package:athena_migrate/src/utils/config.dart';
import 'package:athena_sql/athena_sql.dart';

void athenaMigrate(
    List<String> args,
    AthenaSQL<AthenaDatabaseConnectionDriver> athena,
    List<AthenaMigration> migrations) {
  final config = ReadConfig().run();
  if (config == null) {
    print('Config file not found');
    exit(1);
  }
  athena.tableExists('table');
  Future.forEach(migrations, (migration) async {
    await migration.up(athena);
  });
}
