part of '../builders.dart';

extension ColumnBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> $customType(String name,
          {required String type,
          List<String>? parameters,
          List<String>? posParameters}) =>
      _changeBuilder(ColumnSchema(_driver.mapColumnOrTable(name), type,
          parameters: parameters, posParameters: posParameters));
}

extension ColumnDefaultsBuilder<D extends AthenaDatabaseDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> _typeFromDef(
          String name, ColumnDef columnDef) =>
      _changeBuilder(ColumnSchema(name, columnDef.type,
          parameters: columnDef.parameters,
          posParameters: columnDef.posParameters));

  AthenaQueryBuilder<D, ColumnSchema> string(String name) =>
      _typeFromDef(name, _driver.columns.string());
  AthenaQueryBuilder<D, ColumnSchema> boolean(String name) =>
      _typeFromDef(name, _driver.columns.boolean());
  AthenaQueryBuilder<D, ColumnSchema> integer(String name) =>
      _typeFromDef(name, _driver.columns.integer());
}
