import 'package:athena_sql/src/migrations/command.dart';
import 'package:collection/collection.dart';

import '../athena_sql.dart';
import 'builders/builders.dart';

class AthenaSQL<D extends AthenaDriver> {
  final D driver;
  AthenaSQL(this.driver);

  CreateBuilder<D> get create => CreateBuilder(driver);

  DropBuilder<D> get drop => DropBuilder(driver);


}

extension AthenaDatabaseExtension on AthenaSQL<AthenaDatabaseDriver> {

  Future<bool> tableExists(String table) => driver.tableExists(table);
  Future<AthenaQueryResponse> rawQuery(
    String queryString, {
    Map<String, dynamic>? mapValues,
  }) =>
      driver.query(queryString, mapValues: mapValues);
}
extension AthenaDatabaseConnectionExtension on AthenaSQL<AthenaDatabaseConnectionDriver> {
  Future<void> open() => driver.open();
  Future<void> close() => driver.close();
  Future<T> transaction<T>(
      Future<T> Function(AthenaSQL<AthenaDatabaseDriver> athenasql) trx) {
    return driver.transaction((driver) => trx(AthenaSQL(driver)));
  }
  Future<void> migrate(List<AthenaMigration> migrations, List<String> args) async {
    await MigrationCommands(migrations.sorted((a, b) => a.date.compareTo(b.date)), args, this).run();
  }
}

abstract class AthenaMigration {
  final String name;
  final String date;
  const AthenaMigration(this.name, this.date);
  Future<void> up(AthenaSQL<AthenaDatabaseDriver> db);
  Future<void> down(AthenaSQL<AthenaDatabaseDriver> db);
}
