part of 'where.dart';

abstract class WhereClause extends QueryBuilder {
  const WhereClause();

  WhereJoins and(WhereClause value) {
    return WhereJoins(this, Operators.and, value);
  }

  WhereJoins operator &(WhereClause value) {
    return and(value);
  }

  WhereJoins or(WhereClause value) {
    return WhereJoins(this, Operators.or, value);
  }

  WhereJoins operator |(WhereClause value) {
    return or(value);
  }
}

enum Condition {
  gt('>'),
  gte('>='),
  lt('<'),
  lte('<='),
  eq('='),
  neq('!='),
  like('LIKE'),
  inList('IN'),
  notInList('NOT IN');

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

enum ConditionUnary {
  not('NOT'),
  isNull('IS NULL'),
  isNotNull('IS NOT NULL');

  const ConditionUnary(this.value);
  final String value;
}

class WhereUnary extends WhereClause {
  final ConditionUnary condition;
  final WhereItem item;

  const WhereUnary(this.item, this.condition);

  @override
  QueryPrintable build() =>
      QueryString().keyword(condition.value).space().adding(item);
}

enum Operators {
  and("AND"),
  or("OR");

  const Operators(this.value);
  final String value;
}

class WhereJoins extends WhereClause {
  final Operators operator;
  final WhereClause leftCondition;
  final WhereClause rightCondition;

  const WhereJoins(this.leftCondition, this.operator, this.rightCondition);
  @override
  QueryPrintable build() => QueryString()
      .adding(leftCondition)
      .space()
      .keyword(operator.value)
      .space()
      .adding(rightCondition);
}
