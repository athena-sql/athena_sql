import 'package:athena_sql/src/utils/query_string.dart';

import 'dml_schema.dart';

class InsertTableSchema extends DMLSchema {
  final String name;
  final List<Map<String, dynamic>> values;
  InsertTableSchema({required this.name, required this.values});
  @override
  QueryPrintable build() {
    // all values keys
    final keys = values.map((e) => e.keys).expand((element) => element).toSet();
    final valuesString =
        values.map((e) => keys.map((key) => e[key]).toList()).toList();

    return QueryString()
        .keyword('INSERT')
        .keyword('INTO')
        .userInput(name)
        .parentheses((q) =>
            q.commaSeparated(keys.map((e) => QueryString().userInput(e))))
        .keyword('VALUES')
        .parentheses((q) => q.commaSeparated(valuesString
            .map((e) => QueryString().parentheses((q) => q.commaSeparated(
                e.map((e) => QueryString().userInput(e)).toList())))
            .toList()));
  }

  copyWith({String? name, List<Map<String, dynamic>>? values}) {
    return InsertTableSchema(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  copyWithAddValues(Map<String, dynamic> values) {
    copyWith(values: [
      ...this.values,
      values,
    ]);
  }
}
