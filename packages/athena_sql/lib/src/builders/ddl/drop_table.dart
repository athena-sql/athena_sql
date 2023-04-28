part of '../builders.dart';

extension DropTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, DropTableSchema> {
  AthenaQueryBuilder<D, DropTableSchema> ifExists() =>
      _copyWith(schema: $schema.copyWith(ifExists: true));
  AthenaQueryBuilder<D, DropTableSchema> cascade() =>
      _copyWith(schema: $schema.copyWith(type: DropTableType.cascade));
  AthenaQueryBuilder<D, DropTableSchema> restrict() =>
      _copyWith(schema: $schema.copyWith(type: DropTableType.restrict));
  AthenaQueryBuilder<D, DropTableSchema> table(String name) =>
      _copyWith(schema: $schema.copyWith(names: [...$schema.names, name]));
}
