import 'package:athena_sql/src/schemas/ddl/ddl_schema.dart';

import '../../utils/query_string.dart';

enum DropTableType {
  cascade('CASCADE'),
  restrict('RESTRICT');

  final String value;
  const DropTableType(this.value);
}

class DropTableSchema extends DdlSchema {
  final List<String> names;
  final bool? ifExists;
  final DropTableType? type;
  DropTableSchema({required this.names, this.ifExists = false, this.type});

  @override
  QueryString build() => QueryString()
      .keyword('DROP TABLE ')
      .condition(ifExists, (q) => q.keyword('IF EXISTS '))
      .commaSeparated(names.map((e) => QueryString().userInput(e)))
      .notNull(type, (q, val) => q.space().keyword(val.value));

  DropTableSchema copyWith(
      {List<String>? names, bool? ifExists, DropTableType? type}) {
    return DropTableSchema(
        names: names ?? this.names,
        ifExists: ifExists ?? this.ifExists,
        type: type ?? this.type);
  }
}

class DropViewSchema {}
