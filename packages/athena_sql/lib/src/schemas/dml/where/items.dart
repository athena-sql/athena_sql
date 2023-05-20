part of 'where.dart';

abstract class WhereItem extends QueryBuilder {
  const WhereItem();
}

enum ConditionModifier {
  not('NOT');

  final String value;
  const ConditionModifier(this.value);
}

class WhereModifier extends WhereItem {
  final WhereItem item;
  final ConditionModifier modifier;

  WhereModifier(this.item, this.modifier) : super();

  @override
  QueryPrintable build() =>
      QueryString().adding(item.build()).space().keyword(modifier.value);
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
