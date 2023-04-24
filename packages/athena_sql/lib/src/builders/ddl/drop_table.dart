part of '../builders.dart';

extension DropTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, DropTableSchema> {
  AthenaQueryBuilder<D, DropTableSchema> ifExists() =>
      _copyWith(schema: _schema.copyWith(ifExists: true));
  AthenaQueryBuilder<D, DropTableSchema> cascade() =>
      _copyWith(schema: _schema.copyWith(type: DropTableType.cascade));
  AthenaQueryBuilder<D, DropTableSchema> restrict() =>
      _copyWith(schema: _schema.copyWith(type: DropTableType.restrict));
  AthenaQueryBuilder<D, DropTableSchema> table(String name) =>
      _copyWith(schema: _schema.copyWith(names: [..._schema.names, name]));
}
