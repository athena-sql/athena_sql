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

  WhereCondition isIn(List<WhereItemValue> items) {
    final value = WhereItemList.fromItems(items);
    return WhereCondition(this, Condition.isIn, value);
  }

  WhereCondition isNotIn(List<WhereItemValue> items) {
    final value = WhereItemList.fromItems(items);
    return WhereCondition(this, Condition.isNotIn, value);
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

class WhereItemList extends WhereItem {
  final List<String> values;
  const WhereItemList(this.values);
  WhereItemList.fromItems(List<WhereItemValue> items)
      : values = items.map((e) => e.value).toList();

  @override
  QueryPrintable build() => QueryString().parentheses((q) =>
      q.comaSpaceSeparated(values.map((e) => QueryString().userInput(e))));
}
