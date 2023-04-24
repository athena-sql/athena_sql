part of '../builders.dart';

extension CreateTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateTableSchema> {
  AthenaQueryBuilder<D, CreateTableSchema> column(
      AthenaQueryBuilder<D, ColumnSchema> Function(
              AthenaQueryBuilder<D, CreateColumnSchema> t)
          table) {
    final clauses = table(_changeBuilder(CreateColumnSchema()));
    return _copyWith(
        schema:
            _schema.copyWith(clauses: [..._schema.clauses, clauses._schema]));
  }
}
