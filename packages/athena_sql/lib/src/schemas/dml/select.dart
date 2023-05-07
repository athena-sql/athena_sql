import 'package:athena_sql/src/schemas/dml/where/where.dart';
import 'package:athena_sql/src/utils/query_string.dart';

import 'dml_schema.dart';

class SelectTableSchema extends DMLSchema {
  final List<String> columns;
  final String from;
  final String? as;
  final WhereClause? where;

  const SelectTableSchema(this.from,
      {required this.columns, this.as, this.where});
  @override
  QueryPrintable build() => QueryString()
      .keyword('SELECT ')
      .comaSpaceSeparated(
          columns.map((column) => QueryString().userInput(column)))
      .keyword(' FROM ')
      .userInput(from)
      .condition(as != null, (q) => q.keyword(' AS ').userInput(as!))
      .condition(where != null, (q) => q.keyword(' WHERE ').adding(where!));

  SelectTableSchema copyWith(
      {List<String>? columns, String? from, String? as, WhereClause? where}) {
    return SelectTableSchema(
      from ?? this.from,
      columns: columns ?? this.columns,
      as: as ?? this.as,
      where: where ?? this.where,
    );
  }
}
