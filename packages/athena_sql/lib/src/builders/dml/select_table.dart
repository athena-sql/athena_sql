part of '../builders.dart';

typedef QueryWhereItemValue<D extends AthenaDriver>
    = AthenaQueryBuilder<D, WhereItemValue>;
typedef QueryWhereItem<D extends AthenaDriver>
    = AthenaQueryBuilder<D, WhereItem>;
typedef QueryWhereClause<D extends AthenaDriver>
    = AthenaQueryBuilder<D, WhereClause>;
typedef QueryWhereCondition<D extends AthenaDriver>
    = AthenaQueryBuilder<D, WhereCondition>;

extension WhereTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, WhereCreatorSchema> {
  QueryWhereItemValue<D> _itemValue(String value) {
    return _changeBuilder(WhereItemValue(value));
  }

  QueryWhereItemValue<D> $numeric(num value) {
    return _itemValue('$value');
  }

  QueryWhereItemValue<D> $text(String value) {
    return _itemValue('\'$value\'');
  }

  QueryWhereItemValue<D> $variable(String value) {
    return _itemValue('@$value');
  }

  QueryWhereItemValue<D> $value(String val) {
    return _itemValue(_driver.mapColumnOrTable(val));
  }

  QueryWhereItemValue<D> operator [](String value) => this.$value(value);
}

extension WhereClauseBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, WhereClause> {
  QueryWhereClause<D> and(QueryWhereClause<D> clasue) {
    return _changeBuilder(
        WhereOperatorClause($schema, WhereOperator.and, clasue.$schema));
  }

  QueryWhereClause<D> or(QueryWhereClause<D> clasue) {
    return _changeBuilder(
        WhereOperatorClause($schema, WhereOperator.or, clasue.$schema));
  }

  QueryWhereClause<D> operator &(QueryWhereClause<D> clasue) {
    return and(clasue);
  }

  QueryWhereClause<D> operator |(QueryWhereClause<D> clasue) {
    return or(clasue);
  }
}

extension WhereItemBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, WhereItem> {
  QueryWhereCondition<D> _condition(Condition condition, WhereItem value) {
    return _changeBuilder(WhereCondition($schema, condition, value));
  }

  String _toString(Object value) {
    if (value is String) {
      if (value.startsWith('@')) {
        return value;
      }
      return '\'$value\'';
    }
    return '$value';
  }

  WhereItem _item(Object value) {
    if (value is QueryWhereItem<dynamic>) {
      return value.$schema;
    }
    if (value is WhereItem) {
      return value;
    }
    return WhereItemValue(_toString(value));
  }

  QueryWhereCondition<D> operator >(Object value) {
    return _condition(Condition.gt, _item(value));
  }

  QueryWhereCondition<D> operator >=(Object value) {
    return _condition(Condition.gte, _item(value));
  }

  QueryWhereCondition<D> operator <(Object value) {
    return _condition(Condition.lt, _item(value));
  }

  QueryWhereCondition<D> operator <=(Object value) {
    return _condition(Condition.lte, _item(value));
  }

  QueryWhereCondition<D> eq(Object value) {
    return _condition(Condition.eq, _item(value));
  }

  QueryWhereCondition<D> noEq(Object value) {
    return _condition(Condition.neq, _item(value));
  }

  QueryWhereCondition<D> like(Object value) {
    return _condition(Condition.like, _item(value));
  }

  WhereItem _in(Object value) {
    if (value is List<AthenaQueryBuilder<dynamic, WhereItemValue>>) {
      return WhereItemList.fromItems(value.map((e) => e.$schema).toList());
    }
    if (value is List<WhereItemValue>) {
      return WhereItemList.fromItems(value);
    }
    if (value is List<WhereItemValue>) {
      return WhereItemList.fromItems(value);
    }
    if (value is List<dynamic>) {
      return WhereItemList.fromItems(
          value.map((e) => WhereItemValue(_toString(e))).toList());
    }
    throw Exception('Invalid value for IN clause');
  }

  QueryWhereCondition<D> isIn(Object value) {
    return _condition(Condition.isIn, _in(value));
  }

  AthenaQueryBuilder<D, WhereNullable> isNull() {
    return _changeBuilder(WhereNullable($schema, ConditionNullable.isNull));
  }

  AthenaQueryBuilder<D, WhereNullable> isNotNull() {
    return _changeBuilder(WhereNullable($schema, ConditionNullable.isNotNull));
  }

  AthenaQueryBuilder<D, WhereModifier> not() {
    return _changeBuilder(WhereModifier($schema, ConditionModifier.not));
  }
}

extension SelectTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, SelectTableSchema> {
  AthenaQueryBuilder<D, SelectTableSchema> as(String alias) {
    return _changeBuilder($schema.copyWith(as: alias));
  }

  AthenaQueryBuilder<D, SelectTableSchema> where(
    AthenaQueryBuilder<D, WhereClause> Function(
            AthenaQueryBuilder<D, WhereCreatorSchema>)
        builder,
  ) {
    final clause = builder(_changeBuilder(WhereCreatorSchema()));
    if ($schema.where == null) {
      return _changeBuilder($schema.copyWith(where: clause.$schema));
    } else {
      return _changeBuilder($schema.copyWith(
          where: WhereOperatorClause(
              $schema.where!, WhereOperator.and, clause.$schema)));
    }
  }
}
