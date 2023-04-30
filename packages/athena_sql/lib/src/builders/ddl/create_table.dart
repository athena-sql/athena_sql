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
            $schema.copyWith(clauses: [...$schema.clauses, clauses.$schema]));
  }

  AthenaQueryBuilder<D, CreateTableSchema> ifNotExists() {
    return _copyWith(schema: $schema.copyWith(ifNotExists: true));
  }

  AthenaQueryBuilder<D, CreateTableSchema> temporary() {
    return _copyWith(schema: $schema.copyWith(temporary: true));
  }
}
