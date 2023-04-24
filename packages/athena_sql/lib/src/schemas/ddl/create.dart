import '../../utils/query_string.dart';
import 'shared.dart';

class CreateTableSchema extends QueryBuilder {
  final String tableName;
  final Locale? locale;
  final bool? temporary;
  final bool? ifNotExists;
  final List<CreateTableClause> clauses;
  CreateTableSchema(this.tableName,
      {this.locale,
      this.temporary,
      this.ifNotExists,
      List<CreateTableClause>? clauses})
      :clauses =
            clauses ?? const <CreateTableClause>[];

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
      .keyword('CREATE TABLE ')
      .condition(temporary == true, (q) => q.keyword('TEMPORARY '))
      .condition(ifNotExists == true, (q) => q.keyword('IF NOT EXISTS '))
      .userInput(tableName)
      .parentesis((q) => q.comaSpaceSeparated(clauses));
}
