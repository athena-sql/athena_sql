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
    return {
      for (var element in listValues
          .mapIndexed((index, element) => MapEntry(index, element)))
        ...element.value
            .map((key, value) => MapEntry('${key}_${element.key}', value))
    };
  }

  Set<String> get _keys =>
      listValues.map((e) => e.keys).expand((element) => element).toSet();

  Map<String, String> _mapKeys(String Function(String) keyMapper) =>
      Map<String, String>.fromIterable(_keys, value: (k) => keyMapper(k));

  InsertTableSchema copyMappingColumns(String Function(String) keyMapper) =>
      copyWith(mapColumn: _mapKeys((k) => keyMapper(k)));

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

class InsertTableReturningSchema extends DMLSchema {
  InsertTableSchema schema;
  List<String> returning;
  InsertTableReturningSchema(this.schema, this.returning);

  @override
  QueryPrintable build() {
    return QueryString()
        .adding(schema)
        .space()
        .keyword('RETURNING ')
        .comaSpaceSeparated(returning.map((e) => QueryString().userInput(e)));
  }

  InsertTableReturningSchema copyMappingColumns(
      String Function(String) keyMapper) {
    return copyWith(schema: schema.copyMappingColumns(keyMapper));
  }

  Map<String, dynamic> mapValues() {
    return schema.mapValues();
  }

  InsertTableReturningSchema copyWith(
      {InsertTableSchema? schema, List<String>? returning}) {
    return InsertTableReturningSchema(
      schema ?? this.schema,
      returning ?? this.returning,
    );
  }
}
