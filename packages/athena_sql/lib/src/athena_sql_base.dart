import 'package:athena_sql/src/schemas/ddl/ddl.dart';

import '../athena_sql.dart';
import 'driver.dart';

class AthenaSQL<D extends AthenaDriver> {
  final D driver;
  AthenaSQL(this.driver);

  AthenaQueryBuilder<D, CreateTableSchema> createTable(String name) =>
      AthenaQueryBuilder(driver, CreateTableSchema(name));

  DropBuilder<D> get drop => DropBuilder(driver);
}
