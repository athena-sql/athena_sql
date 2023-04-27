part of '../builders.dart';

typedef CSBuilder<D extends AthenaDriver> = AthenaQueryBuilder<D, ColumnSchema>;

extension ColumnOptionsBuilder<D extends AthenaDriver> on CSBuilder<D> {
  CSBuilder<D> _addingContrain(ColumnConstrains constraint) {
    return _copyWith(
        schema: _schema
            .copyWith(constraints: [..._schema.constraints, constraint]));
  }

  CSBuilder<D> notNull({String? name}) {
    return _addingContrain(NotNullContraint(name: name));
  }

  CSBuilder<D> primaryKey({String? name}) {
    return _addingContrain(PrimaryKeyContraint(name: name));
  }

  CSBuilder<D> unique({String? name, bool? nullsNotDistinct}) {
    return _addingContrain(
        UniqueContraint(name: name, nullsNotDistinct: nullsNotDistinct));
  }

  CSBuilder<D> check(String expression, {String? name}) {
    return _addingContrain(CheckContraint(expression, name: name));
  }

  CSBuilder<D> references(String tableName,
      {String? name,
      String? column,
      ReferencialAction Function(ReferencialActionRuleBuilder)? on}) {
    return _addingContrain(ReferencesContraint(
        name: name, column: column, table: tableName, on: on));
  }

  CSBuilder<D> defaultTo(String value) {
    return _addingContrain(DefaultContraint(value));
  }

  CSBuilder<D> collate(String collate) {
    return _copyWith(schema: _schema.copyWith(collate: collate));
  }

  CSBuilder<D> compression(String compression) {
    return _copyWith(schema: _schema.copyWith(compression: compression));
  }
}
