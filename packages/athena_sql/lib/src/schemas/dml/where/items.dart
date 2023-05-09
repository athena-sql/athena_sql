part of 'where.dart';

abstract class WhereItem extends QueryBuilder {
  const WhereItem();

  WhereCondition operator >(WhereItem value) {
    return WhereCondition(this, Condition.gt, value);
  }

  WhereCondition operator >=(WhereItem value) {
    return WhereCondition(this, Condition.gte, value);
  }

  WhereCondition operator <(WhereItem value) {
    return WhereCondition(this, Condition.lt, value);
  }

  WhereCondition operator <=(WhereItem value) {
    return WhereCondition(this, Condition.lte, value);
  }

  WhereCondition eq(WhereItem value) {
    return WhereCondition(this, Condition.eq, value);
  }

  WhereCondition noEq(WhereItem value) {
    return WhereCondition(this, Condition.neq, value);
  }

  WhereCondition like(WhereItem value) {
    return WhereCondition(this, Condition.like, value);
  }

  WhereCondition inList(WhereItem value) {
    return WhereCondition(this, Condition.inList, value);
  }

  WhereCondition notInList(WhereItem value) {
    return WhereCondition(this, Condition.notInList, value);
  }

  WhereUnary isNull() {
    return WhereUnary(this, ConditionUnary.isNull);
  }

  WhereUnary isNotNull() {
    return WhereUnary(this, ConditionUnary.isNotNull);
  }

  WhereUnary not() {
    return WhereUnary(this, ConditionUnary.not);
  }
}

class WhereItemValue extends WhereItem {
  final String value;
  const WhereItemValue(this.value);

  @override
  QueryPrintable build() => QueryString().userInput(value);
}
