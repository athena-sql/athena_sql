import 'package:athena_sql/src/schemas/ddl/shared.dart';
import 'package:athena_sql/src/utils/query_string.dart';

import 'constraint.dart';

class CreateColumnSchema extends QueryBuilder {
  @override
  QueryPrintable build() => QueryString();
}

class ColumnSchema extends CreateTableClause {
  final String _name;
  final String _type;
  final QueryPrintable? preconstraints;
  final List<ColumnConstrains> constraints;
  final List<String>? _parameters;
  final List<String>? _posParameters;
  ColumnSchema(
    this._name,
    this._type, {
    this.preconstraints,
    this.constraints = const <ColumnConstrains>[],
    List<String>? parameters,
    List<String>? posParameters,
  })  : _parameters = parameters,
        _posParameters = posParameters;

  QueryString typeParameters() => QueryString()
      .keyword(_type)
      .condition(
          _parameters != null && _parameters.isNotEmpty,
          (q) => q.parentheses((q) =>
              q.commaSeparated(_parameters!.map((e) => QueryString.user(e)))))
      .condition(
        _posParameters != null,
        (q) => q.space().join(
            _posParameters!.map((e) => QueryString().keyword(e)),
            QueryString().space()),
      );
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
