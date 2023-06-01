part of '../builders.dart';

extension AlterTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, AlterTableSchema> {
  AthenaQueryBuilder<D, AlterTableSchema> addColumn(
    AthenaQueryBuilder<D, ColumnSchema> Function(
            AthenaQueryBuilder<D, CreateColumnSchema> t)
        table, {
    bool? ifNotExists,
  }) {
    final createColumn = CreateColumnSchema();

    final builder = table(AthenaQueryBuilder(_driver, createColumn));

    return _changeBuilder($schema.copyWith(actions: [
      ...$schema.actions,
      AlterTableActionAddColumn(builder.$schema, ifNotExists: ifNotExists)
    ]));
  }

  AthenaQueryBuilder<D, AlterTableSchema> dropColumn(
    String name, {
    bool? ifExists,
  }) {
    return _changeBuilder($schema.copyWith(actions: [
      ...$schema.actions,
      AlterTableActionDropColumn(name, ifExists: ifExists)
    ]));
  }
}
