import 'package:athena_sql/query_string.dart';

import 'column.dart';
import 'global.dart';

class CreateTable extends QueryBuilder {
  final String tableName;
  final Locale? locale;
  final bool? temporary;
  final bool? ifNotExists;
  final List<TablePosibleAddition> _tablePosibleAdditions;
  CreateTable(this.tableName,
      {this.locale,
      this.temporary,
      this.ifNotExists,
      List<TablePosibleAddition>? tablePosibleAdditions})
      : _tablePosibleAdditions =
            tablePosibleAdditions ?? const <TablePosibleAddition>[];

  CreateTable _copyWith(
      {String? tableName,
      Locale? locale,
      bool? temporary,
      bool? ifNotExists,
      List<TablePosibleAddition>? tablePosibleAdditions}) {
    return CreateTable(tableName ?? this.tableName,
        locale: locale ?? this.locale,
        temporary: temporary ?? this.temporary,
        ifNotExists: ifNotExists ?? this.ifNotExists,
        tablePosibleAdditions: tablePosibleAdditions ?? _tablePosibleAdditions);
  }

  @override
  QueryString build() => QueryString()
      .keyword('CREATE TABLE ')
      .condition(temporary == true, (q) => q.keyword('TEMPORARY '))
      .condition(ifNotExists == true, (q) => q.keyword('IF NOT EXISTS '))
      .userInput(tableName)
      .parentesis((q) => q.comaSpaceSeparated(_tablePosibleAdditions));
}

class CreateTableBuilder {
  final CreateTable _table;
  CreateTableBuilder(String name) : _table = CreateTable(name);
  CreateTableBuilder._(this._table);

  CreateTableBuilder column(
      TablePosibleAddition Function(ColumnBuilder t) table) {
    final tablePosibleAddition = table(ColumnBuilder());
    return CreateTableBuilder._(_table._copyWith(tablePosibleAdditions: [
      ..._table._tablePosibleAdditions,
      tablePosibleAddition
    ]));
  }

  String build() {
    return _table.build().plain();
  }
}
