import 'package:athena_sql/src/utils/query_string.dart';
import 'package:collection/collection.dart';

import 'dml_schema.dart';

class InsertTableSchema extends DMLSchema {
  final String name;
  final List<Map<String, dynamic>> listValues;
  InsertTableSchema({required this.name, required this.listValues});
  @override
  QueryPrintable build() {
    // all values keys
    final keys =
        listValues.map((e) => e.keys).expand((element) => element).toSet();

    final valuesToInsert = listValues
        .mapIndexed((index, values) => keys
            .map((key) => values.containsKey(key) ? '@${key}_$index' : 'NULL')
            .toList())
        .toList();

    return QueryString()
        .keyword('INSERT ')
        .keyword('INTO ')
        .userInput(name)
        .space()
        .parentheses((q) =>
            q.comaSpaceSeparated(keys.map((e) => QueryString().userInput(e))))
        .keyword(' VALUES ')
        .comaSpaceSeparated(valuesToInsert
            .map((e) => QueryString().parentheses((q) =>
                q.comaSpaceSeparated(e.map((e) => QueryString().userInput(e)))))
            .toList());
  }

  Map<String, dynamic> mapValues() {
    return listValues.reduceIndexed((index, previous, element) => {
          ...previous.map((key, value) {
            if (index > 1) {
              return MapEntry(key, value);
            }
            return MapEntry('${key}_${index - 1}', value);
          }),
          ...element.map((key, value) => MapEntry('${key}_$index', value))
        });
  }

  InsertTableSchema copyWith(
      {String? name, List<Map<String, dynamic>>? listValues}) {
    return InsertTableSchema(
      name: name ?? this.name,
      listValues: listValues ?? this.listValues,
    );
  }

  InsertTableSchema copyWithAddValues(Map<String, dynamic> values) {
    return copyWith(listValues: [
      ...listValues,
      values,
    ]);
  }
}
