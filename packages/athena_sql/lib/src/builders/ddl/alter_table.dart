part of '../builders.dart';

extension AlterTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, AlterTableSchema> {
  AthenaQueryBuilder<D, AlterTableSchema> addColumn(
      AthenaQueryBuilder<D, ColumnSchema> Function(
              AthenaQueryBuilder<D, CreateColumnSchema> t)
          table) {
    final createColumn = CreateColumnSchema();

    final builder = table(AthenaQueryBuilder(_driver, createColumn));

    return _changeBuilder($schema.copyWith(actions: [
      ...$schema.actions,
      AlterTableActionAddColumn(builder.$schema)
    ]));
  }

  AthenaQueryBuilder<D, AlterTableSchema> dropColumn(String name) {
    return _changeBuilder($schema.copyWith(
        actions: [...$schema.actions, AlterTableActionDropColumn(name)]));
  }
}
