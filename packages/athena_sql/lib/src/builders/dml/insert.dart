part of '../builders.dart';

extension InsertTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, InsertTableSchema> {
  AthenaQueryBuilder<D, InsertTableSchema> addValues(
      Map<String, dynamic> values) {
    return _changeBuilder($schema.copyWithAddValues(values));
  }

  AthenaQueryBuilder<D, InsertTableSchema> addManyValues(
      List<Map<String, dynamic>> listValues) {
    return _changeBuilder($schema.copyWithAddManyValues(listValues));
  }

  Map<String, dynamic> $mappedValues() {
    return $schema.mapValues();
  }

  AthenaQueryBuilder<D, InsertTableReturningSchema> returning(
      List<String> columns) {
    final mapedColumns = columns.map(_driver.mapColumnOrTable).toList();
    return _changeBuilder(InsertTableReturningSchema($schema, mapedColumns));
  }
}

extension InsertTableReturningBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, InsertTableReturningSchema> {
  Map<String, dynamic> $mappedValues() {
    return $schema.mapValues();
  }
}
