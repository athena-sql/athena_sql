import 'package:athena_sql/src/utils/query_string.dart';
import 'package:collection/collection.dart';

import 'dml_schema.dart';

class InsertTableSchema extends DMLSchema {
  final String name;
  final List<Map<String, dynamic>> listValues;
  final Map<String, String> mapColumn;
  InsertTableSchema(
      {required this.name,
      required this.listValues,
      this.mapColumn = const {}});
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

    final columns = keys.map((key) => mapColumn[key] ?? key).toList();

    return QueryString()
        .keyword('INSERT ')
        .keyword('INTO ')
        .userInput(name)
        .space()
        .parentheses((q) => q.comaSpaceSeparated(
            columns.map((column) => QueryString().userInput(column))))
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
      {String? name,
      List<Map<String, dynamic>>? listValues,
      Map<String, String>? mapColumn}) {
    return InsertTableSchema(
      name: name ?? this.name,
      listValues: listValues ?? this.listValues,
      mapColumn: mapColumn ?? this.mapColumn,
    );
  }

  InsertTableSchema copyWithAddValues(Map<String, dynamic> values) {
    return copyWith(listValues: [
      ...listValues,
      values,
    ]);
  }
}
