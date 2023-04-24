import '../../../athena_sql.dart';
import '../../driver.dart';
import '../../utils/query_string.dart';

class DropBuilder<D extends AthenaDriver> {
  final D driver;
  const DropBuilder(this.driver);

  AthenaQueryBuilder<D, DropTableSchema> table(String name) =>
      AthenaQueryBuilder(driver, DropTableSchema(names: [name]));
}

enum DropTableType {
  cascade('CASCADE'),
  restrict('RESTRICT');

  final String value;
  const DropTableType(this.value);
}

class DropTableSchema extends QueryBuilder {
  final List<String> names;
  final bool? ifExists;
  final DropTableType? type;
  DropTableSchema({required this.names, this.ifExists = false, this.type});

  @override
  QueryString build() => QueryString()
      .keyword('DROP TABLE ')
      .condition(ifExists == true, (q) => q.keyword('IF EXISTS '))
      .comaSeparated(names.map((e) => QueryString().userInput(e)))
      .condition(type != null, (q) => q.space().keyword(type!.value));

  DropTableSchema copyWith(
      {List<String>? names, bool? ifExists, DropTableType? type}) {
    return DropTableSchema(
        names: names ?? this.names,
        ifExists: ifExists ?? this.ifExists,
        type: type ?? this.type);
  }
}

class DropViewSchema {}
