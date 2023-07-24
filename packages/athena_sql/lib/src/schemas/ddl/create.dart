import 'package:athena_sql/src/schemas/ddl/ddl_schema.dart';
import 'package:athena_sql/src/schemas/ddl/table/constraint.dart';

import '../../utils/query_string.dart';
import 'shared.dart';

class CreateTableSchema extends DdlSchema {
  final String tableName;
  final Locale? locale;
  final bool? temporary;
  final bool? ifNotExists;
  final List<CreateTableClause> clauses;
  final List<ColumnConstrains> constraints;
  CreateTableSchema(
    this.tableName, {
    this.locale,
    this.temporary,
    this.ifNotExists,
    List<CreateTableClause>? clauses,
    List<ColumnConstrains>? constraints,
  })  : clauses = clauses ?? const <CreateTableClause>[],
        constraints = constraints ?? const <ColumnConstrains>[];

  CreateTableSchema copyWith(
      {String? tableName,
      Locale? locale,
      bool? temporary,
      bool? ifNotExists,
      List<CreateTableClause>? clauses}) {
    return CreateTableSchema(tableName ?? this.tableName,
        locale: locale ?? this.locale,
        temporary: temporary ?? this.temporary,
        ifNotExists: ifNotExists ?? this.ifNotExists,
        clauses: clauses ?? this.clauses);
  }

  @override
  QueryString build() => QueryString()
      .keyword('CREATE ')
      .condition(temporary, (q) => q.keyword('TEMPORARY '))
      .keyword('TABLE ')
      .condition(ifNotExists, (q) => q.keyword('IF NOT EXISTS '))
      .userInput(tableName)
      .parentheses((q) => q.comaSpaceSeparated(clauses));
}
