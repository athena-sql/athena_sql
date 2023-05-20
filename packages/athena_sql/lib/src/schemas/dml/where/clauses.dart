part of 'where.dart';

abstract class WhereClause extends QueryBuilder {
  const WhereClause();
}

enum Condition {
  gt('>'),
  gte('>='),
  lt('<'),
  lte('<='),
  eq('='),
  neq('!='),
  like('LIKE'),
  isIn('IN');

  const Condition(this.value);
  final String value;
}

class WhereCondition extends WhereClause {
  final WhereItem item;
  final Condition condition;
  final WhereItem value;
  const WhereCondition(this.item, this.condition, this.value);

  @override
  QueryPrintable build() => QueryString()
      .adding(item)
      .space()
      .keyword(condition.value)
      .space()
      .adding(value);
}

enum ConditionNullable {
  isNull('IS NULL'),
  isNotNull('IS NOT NULL');

  const ConditionNullable(this.value);
  final String value;
}

class WhereNullable extends WhereClause {
  final ConditionNullable condition;
  final WhereItem item;

  const WhereNullable(this.item, this.condition);

  @override
  QueryPrintable build() =>
      QueryString().adding(item).space().keyword(condition.value);
}

enum WhereOperator {
  and("AND"),
  or("OR");

  const WhereOperator(this.value);
  final String value;
}

class WhereOperatorClause extends WhereClause {
  final WhereOperator operator;
  final WhereClause leftCondition;
  final WhereClause rightCondition;

  const WhereOperatorClause(
      this.leftCondition, this.operator, this.rightCondition);
  @override
  QueryPrintable build() => QueryString()
      .adding(leftCondition)
      .space()
      .keyword(operator.value)
      .space()
      .adding(rightCondition);
}
