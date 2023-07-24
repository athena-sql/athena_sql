import 'package:athena_sql/src/schemas/dml/where/where.dart';
import 'package:athena_sql/src/utils/query_string.dart';

import 'dml_schema.dart';

enum JoinType {
  inner("INNER"),
  left("LEFT"),
  right("RIGHT"),
  full("FULL"),
  cross("CROSS");

  const JoinType(this.value);
  final String value;
}

class JoinClause extends DMLSchema {
  final bool natural;
  final JoinType? type;
  final String table;
  final String? as;
  final WhereClause? on;

  const JoinClause(
      {required this.table, this.as, this.type, this.on, this.natural = false});

  @override
  QueryPrintable build() => QueryString()
      .condition(natural, (q) => q.keyword('NATURAL '))
      .notNull(
          type,
          (q, t) =>
              q.keyword(type.toString().split('.').last.toUpperCase()).space())
      .keyword('JOIN ')
      .userInput(table)
      .notNull(as, (q, a) => q.keyword(' AS ').userInput(a))
      .notNull(on, (q, o) => q.keyword(' ON ').adding(o));
}

class SelectTableSchema extends DMLSchema {
  final List<String> columns;
  final String from;
  final String? as;
  final WhereClause? where;
  final List<JoinClause>? joins;

  const SelectTableSchema(this.from,
      {required this.columns, this.as, this.where, this.joins});
  @override
  QueryPrintable build() => QueryString()
      .keyword('SELECT ')
      .comaSpaceSeparated(
          columns.map((column) => QueryString().userInput(column)))
      .keyword(' FROM ')
      .userInput(from)
      .notNull(as, (q, a) => q.keyword(' AS ').userInput(a))
      .notNull(joins, (q, j) => q.space().spaceSeparated(j))
      .notNull(where, (q, w) => q.keyword(' WHERE ').adding(w));

  SelectTableSchema copyWith(
      {List<String>? columns,
      String? from,
      String? as,
      WhereClause? where,
      List<JoinClause>? joins}) {
    return SelectTableSchema(
      from ?? this.from,
      columns: columns ?? this.columns,
      as: as ?? this.as,
      where: where ?? this.where,
      joins: joins ?? this.joins,
    );
  }

  SelectTableSchema addJoins(List<JoinClause> joins) {
    final newJoins = (this.joins ?? <JoinClause>[])..addAll(joins);
    return copyWith(joins: newJoins);
  }
}
