part of '../builders.dart';

class CreateBuilder<D extends AthenaDriver> {
  final D _driver;
  CreateBuilder(this._driver);

  AthenaQueryBuilder<D, CreateTableSchema> table(String name) {
    return AthenaQueryBuilder<D, CreateTableSchema>(
        _driver, CreateTableSchema(name));
  }
}

class DropBuilder<D extends AthenaDriver> {
  final D driver;
  const DropBuilder(this.driver);

  AthenaQueryBuilder<D, DropTableSchema> table(String name) =>
      AthenaQueryBuilder(driver, DropTableSchema(names: [name]));
}

class AlterTableSchemaBuilder<D extends AthenaDriver> {
  final D driver;
  final String name;
  AlterTableSchemaBuilder(this.driver, this.name);

  AthenaQueryBuilder<D, AlterTableSchema> addColumn(
      AthenaQueryBuilder<D, ColumnSchema> Function(
              AthenaQueryBuilder<D, CreateColumnSchema> t)
          table) {
    final createColumn = CreateColumnSchema();

    final builder = table(AthenaQueryBuilder(driver, createColumn));
    return builder._changeBuilder(AlterTableSchema(name,
        actions: [AlterTableActionAddColumn(builder.$schema)]));
  }

  AthenaQueryBuilder<D, AlterTableSchema> dropColumn(String column) {
    final builder = AthenaQueryBuilder(driver, AlterTableSchema(name,
        actions: [AlterTableActionDropColumn(column)]));
        
    return builder;
  }
}

class AlterBuilder<D extends AthenaDriver> {
  final D driver;
  const AlterBuilder(this.driver);

  AlterTableSchemaBuilder<D> table(String name) =>
      AlterTableSchemaBuilder(driver, name);
}
