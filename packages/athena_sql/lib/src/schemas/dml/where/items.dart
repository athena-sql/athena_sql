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
  final List<WhereItem> items;
  const WhereItemList(this.items);
  WhereItemList.fromItems(this.items);

  @override
  QueryPrintable build() => QueryString().parentheses((q) =>
      q.comaSpaceSeparated(items.map((item) => QueryString().adding(item))));
}
