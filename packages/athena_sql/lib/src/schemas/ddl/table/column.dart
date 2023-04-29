import 'package:athena_sql/src/schemas/ddl/shared.dart';
import 'package:athena_sql/src/utils/query_string.dart';

import 'constraint.dart';

class CreateColumnSchema extends QueryBuilder {
  @override
  QueryPrintable build() => QueryString();
}

enum IntervalPhrases {
  year('YEAR'),
  month('MONTH'),
  day('DAY'),
  hour('HOUR'),
  minute('MINUTE'),
  second('SECOND'),
  yearToMonth('YEAR TO MONTH'),
  dayToHour('DAY TO HOUR'),
  dayToMinute('DAY TO MINUTE'),
  dayToSecond('DAY TO SECOND'),
  hourToMinute('HOUR TO MINUTE'),
  hourToSecond('HOUR TO SECOND'),
  minuteToSecond('MINUTE TO SECOND');

  final String name;
  const IntervalPhrases(this.name);
}

class ColumnSchema extends CreateTableClause {
  final String _name;
  final String _type;
  final QueryPrintable? preconstraints;
  final List<ColumnConstrains> constraints;
  final List<String>? _parameters;
  ColumnSchema(
    this._name,
    this._type, {
    this.preconstraints,
    this.constraints = const <ColumnConstrains>[],
    List<String>? parameters,
  }) : _parameters = parameters;

  QueryString typeParameters() => QueryString().keyword(_type).condition(
      _parameters != null && _parameters!.isNotEmpty,
      (q) => q.parentesis((q) =>
          q.comaSeparated(_parameters!.map((e) => QueryString.user(e)))));
  @override
  QueryString build() => QueryString()
      .column(_name)
      .space()
      .adding(typeParameters())
      .condition(
          preconstraints != null, (q) => q.space().adding(preconstraints!))
      .condition(constraints.isNotEmpty,
          (q) => q.space().join(constraints, QueryString().space()));

  ColumnSchema copyWith({
    String? name,
    String? type,
    QueryPrintable? preconstraints,
    List<ColumnConstrains>? constraints,
    List<String>? parameters,
  }) {
    return ColumnSchema(
      name ?? _name,
      type ?? _type,
      preconstraints: preconstraints ?? this.preconstraints,
      constraints: constraints ?? this.constraints,
      parameters: parameters ?? _parameters,
    );
  }
}
