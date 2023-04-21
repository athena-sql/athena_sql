

// create a postgresql quiery builder for migrations

class CreateTableQuery {
  final String tableName;
  final List<String> columns;
  final List<String> constraints;

  CreateTableQuery(this.tableName, this.columns, this.constraints);

  String build() {
    final sb = StringBuffer();
    sb.write('CREATE TABLE $tableName (');
    sb.write(columns.join(', '));
    sb.write(');');
    return sb.toString();
  }
}

class ColumnDef {
  final String name;
  final String type;
  final bool isNullable;
  final bool isPrimaryKey;
  final bool isUnique;
  final bool isAutoIncrement;
  final String? defaultValue;

  ColumnDef(
    this.name,
    this.type, {
    this.isNullable = false,
    this.isPrimaryKey = false,
    this.isUnique = false,
    this.isAutoIncrement = false,
    this.defaultValue,
  });

  String build() {
    final sb = StringBuffer();
    sb.write('$name $type');
    if (isNullable) {
      sb.write(' NULL');
    } else {
      sb.write(' NOT NULL');
    }
    if (isPrimaryKey) {
      sb.write(' PRIMARY KEY');
    }
    if (isUnique) {
      sb.write(' UNIQUE');
    }
    if (isAutoIncrement) {
      sb.write(' AUTOINCREMENT');
    }
    if (defaultValue != null) {
      sb.write(' DEFAULT $defaultValue');
    }
    return sb.toString();
  }
}

enum ColumnType {
  integer,
  text,
  real,
  blob,
}

class CreateTableBuilder {
  final String tableName;
  List<ColumnDef> columns = <ColumnDef>[];
  List<String> constraints = <String>[];

  CreateTableBuilder(this.tableName);

  void addColumn(
    String name,
    String type, {
    bool isNullable = false,
    bool isPrimaryKey = false,
    bool isUnique = false,
    bool isAutoIncrement = false,
    String? defaultValue,
  }) {
    columns.add(ColumnDef(
      name,
      type,
      isNullable: isNullable,
      isPrimaryKey: isPrimaryKey,
      isUnique: isUnique,
      isAutoIncrement: isAutoIncrement,
      defaultValue: defaultValue,
    ));
  }

  void addConstraint(String constraint) {
    constraints.add(constraint);
  }

  CreateTableQuery build() {
    return CreateTableQuery(tableName, columns.map((e) => e.build()).toList(),
        constraints);
  }
}