import 'package:athena_sql/src/utils/query_string.dart';

import '../../../schemas.dart';

// define AlterTableAction
abstract class AlterTableAction extends QueryBuilder {}

// define AlterTableActionAddColumn
class AlterTableActionAddColumn extends AlterTableAction {
  final ColumnSchema column;
  final bool? ifNotExists;

  AlterTableActionAddColumn(
    this.column, {
    this.ifNotExists,
  });

  @override
  QueryString build() => QueryString()
      .keyword('ADD COLUMN ')
      .condition(ifNotExists, (q) => q.keyword('IF NOPT EXISTS '))
      .adding(column);
}

// define AlterTableActionDropColumn
class AlterTableActionDropColumn extends AlterTableAction {
  final String name;
  final bool? ifExists;

  AlterTableActionDropColumn(this.name, {this.ifExists});

  @override
  QueryString build() => QueryString()
      .keyword('DROP COLUMN ')
      .condition(ifExists, (q) => q.keyword('IF EXISTS '))
      .userInput(name);
}

class AlterTableSchema extends DdlSchema {
  final String name;
  final List<AlterTableAction> actions;
  final bool? ifExists;

  AlterTableSchema(
    this.name, {
    required this.actions,
    this.ifExists,
  });

  @override
  QueryString build() => QueryString()
      .keyword('ALTER TABLE ')
      .condition(ifExists, (q) => q.keyword('IF EXISTS '))
      .userInput(name)
      .space()
      .comaSpaceSeparated(actions);

  AlterTableSchema copyWith(
      {String? name, List<AlterTableAction>? actions, bool? ifExists}) {
    return AlterTableSchema(
      name ?? this.name,
      actions: actions ?? this.actions,
      ifExists: ifExists ?? this.ifExists,
    );
  }
}
