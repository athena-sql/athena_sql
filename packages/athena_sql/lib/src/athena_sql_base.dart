import '../athena_sql.dart';
import 'builders/builders.dart';

class AthenaSQL<D extends AthenaDriver> {
  final D driver;
  AthenaSQL(this.driver);

  CreateBuilder<D> get create => CreateBuilder(driver);

  DropBuilder<D> get drop => DropBuilder(driver);
}


extension AthenaDatabaseExtension on AthenaSQL<AthenaDatabaseDriver> {
  Future<void> open() => driver.open();
}


abstract class AthenaMigration {
  final String name;
  final String date;
  const AthenaMigration(this.name, this.date);
  Future<void> up(AthenaSQL<AthenaDatabaseDriver> db);
  Future<void> down(AthenaSQL<AthenaDatabaseDriver> db);
}