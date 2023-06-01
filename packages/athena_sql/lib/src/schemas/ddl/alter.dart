import 'package:athena_sql/src/utils/query_string.dart';

import '../../../schemas.dart';

// define AlterTableAction
abstract class AlterTableAction extends QueryBuilder {}

// define AlterTableActionAddColumn
class AlterTableActionAddColumn extends AlterTableAction {
  final ColumnSchema column;

  AlterTableActionAddColumn(this.column);

  @override
  QueryString build() => QueryString().keyword('ADD COLUMN ').adding(column);
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
      .condition(ifExists == true, (q) => q.keyword('IF EXISTS '))
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
