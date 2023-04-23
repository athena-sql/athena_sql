import 'package:athena_sql/query_string.dart';

import 'constraint.dart';
import 'global.dart';

class ColumnType {
  final String type;
  const ColumnType._(this.type);

  static const bigint = ColumnType._('BIGINT');
  static const int8 = ColumnType._('INT8');
  static const bigserial = ColumnType._('BIGSERIAL');
  static const serial8 = ColumnType._('SERIAL8');
  static const bit = ColumnType._('BIT');
  static const bitVarying = ColumnType._('BIT VARYING');
  static const varbit = ColumnType._('VARBIT');
  static const boolean = ColumnType._('BOOLEAN');
  static const bool = ColumnType._('BOOL');
  static const box = ColumnType._('BOX');
  static const bytea = ColumnType._('BYTEA');
  static const character = ColumnType._('CHARACTER');
  static const char = ColumnType._('CHAR');
  static const characterVarying = ColumnType._('CHARACTER VARYING');
  static const varchar = ColumnType._('VARCHAR');
  static const cidr = ColumnType._('CIDR');
  static const circle = ColumnType._('CIRCLE');
  static const date = ColumnType._('DATE');
  static const doublePrecision = ColumnType._('DOUBLE PRECISION');
  static const float8 = ColumnType._('FLOAT8');
  static const inet = ColumnType._('INET');
  static const integer = ColumnType._('INTEGER');
  static const int = ColumnType._('INT');
  static const int4 = ColumnType._('INT4');
  static const interval = ColumnType._('INTERVAL');
  static const json = ColumnType._('JSON');
  static const jsonb = ColumnType._('JSONB');
  static const line = ColumnType._('LINE');
  static const lseg = ColumnType._('LSEG');
  static const macaddr = ColumnType._('MACADDR');
  static const macaddr8 = ColumnType._('MACADDR8');
  static const money = ColumnType._('MONEY');
  static const numeric = ColumnType._('NUMERIC');
  static const decimal = ColumnType._('DECIMAL');
  static const path = ColumnType._('PATH');
  static const pgLsn = ColumnType._('PG_LSN');
  static const pgSnapshot = ColumnType._('PG_SNAPSHOT');
  static const point = ColumnType._('POINT');
  static const polygon = ColumnType._('POLYGON');
  static const real = ColumnType._('REAL');
  static const float4 = ColumnType._('FLOAT4');
  static const smallint = ColumnType._('SMALLINT');
  static const int2 = ColumnType._('INT2');
  static const smallserial = ColumnType._('SMALLSERIAL');
  static const serial2 = ColumnType._('SERIAL2');
  static const serial = ColumnType._('SERIAL');
  static const serial4 = ColumnType._('SERIAL4');
  static const text = ColumnType._('TEXT');
  static const time = ColumnType._('TIME');
  static const timeWithoutTimeZone = ColumnType._('TIME WITHOUT TIME ZONE');
  static const timeWithTimeZone = ColumnType._('TIME WITH TIME ZONE');
  static const timetz = ColumnType._('TIMETZ');
  static const timestamp = ColumnType._('TIMESTAMP');
  static const timestampWithoutTimeZone =
      ColumnType._('TIMESTAMP WITHOUT TIME ZONE');
  static const timestampWithTimeZone = ColumnType._('TIMESTAMP WITH TIME ZONE');
  static const timestamptz = ColumnType._('TIMESTAMPTZ');
  static const tsquery = ColumnType._('TSQUERY');
  static const tsvector = ColumnType._('TSVECTOR');
  static const txidSnapshot = ColumnType._('TXID_SNAPSHOT');
  static const uuid = ColumnType._('UUID');
  static const xml = ColumnType._('XML');
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

class ColumnBuilder {
  TableColumnDefinition _build(String name, ColumnType type,
      {List<String>? parameters}) {
    return TableColumnDefinition._(name, type, parameters: parameters);
  }

  /// signed eight-byte integer
  ///
  /// *(alias: `int8`)*
  TableColumnDefinition bigint(String name) => _build(name, ColumnType.bigint);

  /// signed eight-byte integer
  TableColumnDefinition int8(String name) => _build(name, ColumnType.int8);

  /// autoincrementing eight-byte integer
  ///
  /// *(alias: `serial8`)*
  TableColumnDefinition bigserial(String name) =>
      _build(name, ColumnType.bigserial);

  /// autoincrementing eight-byte integer
  TableColumnDefinition serial8(String name) =>
      _build(name, ColumnType.serial8);

  /// fixed-length bit string
  TableColumnDefinition bit(String name, int n) =>
      _build(name, ColumnType.bit, parameters: ['$n']);

  /// variable-length bit string
  TableColumnDefinition bitVarying(String name, int n) =>
      _build(name, ColumnType.bitVarying, parameters: ['$n']);

  /// variable-length bit string
  TableColumnDefinition varbit(String name, int n) =>
      _build(name, ColumnType.varbit, parameters: ['$n']);

  /// logical Boolean (true/false)
  ///
  /// *(alias: `bool`)*
  TableColumnDefinition boolean(String name) =>
      _build(name, ColumnType.boolean);

  /// logical Boolean (true/false)
  TableColumnDefinition bool(String name) => _build(name, ColumnType.bool);

  /// rectangular box on a plane
  TableColumnDefinition box(String name) => _build(name, ColumnType.box);

  /// binary data (“byte array”)
  TableColumnDefinition bytea(String name) => _build(name, ColumnType.bytea);

  /// **fixed-length character string**
  ///
  /// *(alias: char [ `(n)` ])*
  TableColumnDefinition character(String name, int n) =>
      _build(name, ColumnType.character, parameters: ['$n']);

  /// fixed-length character string
  TableColumnDefinition char(String name, int n) =>
      _build(name, ColumnType.char, parameters: ['$n']);

  /// variable-length character string
  ///
  /// *(alias: `varchar [ (n) ]`)*
  TableColumnDefinition characterVarying(String name, int n) =>
      _build(name, ColumnType.characterVarying, parameters: ['$n']);

  /// variable-length character string
  TableColumnDefinition varchar(String name, int n) =>
      _build(name, ColumnType.varchar, parameters: ['$n']);

  ///IPv4 or IPv6 network address
  TableColumnDefinition cidr(String name) => _build(name, ColumnType.cidr);

  ///circle on a plane
  TableColumnDefinition circle(String name) => _build(name, ColumnType.circle);

  ///calendar date (year, month, day)
  TableColumnDefinition date(String name) => _build(name, ColumnType.date);

  ///double precision floating-point number (8 bytes)
  ///
  ///*(alias: `float8`)*
  TableColumnDefinition doublePrecision(String name) =>
      _build(name, ColumnType.doublePrecision);

  ///double precision floating-point number (8 bytes)
  TableColumnDefinition float8(String name) => _build(name, ColumnType.float8);

  ///IPv4 or IPv6 host address
  TableColumnDefinition inet(String name) => _build(name, ColumnType.inet);

  ///signed four-byte integer
  ///
  ///*(alias: `int`, `int4`)*
  TableColumnDefinition integer(String name) =>
      _build(name, ColumnType.integer);

  ///signed four-byte integer
  TableColumnDefinition int_(String name) => _build(name, ColumnType.int);

  ///signed four-byte integer
  TableColumnDefinition int4(String name) => _build(name, ColumnType.int4);

  ///time span
  TableColumnDefinition interval(String name, IntervalPhrases fields, int p) =>
      _build(name, ColumnType.interval, parameters: ['$fields', '$p']);

  ///JSON data
  TableColumnDefinition json(String name) => _build(name, ColumnType.json);

  ///binary JSON data, decomposed
  TableColumnDefinition jsonb(String name) => _build(name, ColumnType.jsonb);

  ///infinite line on a plane
  TableColumnDefinition line(String name) => _build(name, ColumnType.line);

  ///line segment on a plane
  TableColumnDefinition lseg(String name) => _build(name, ColumnType.lseg);

  ///MAC (Media Access Control) address
  TableColumnDefinition macaddr(String name) =>
      _build(name, ColumnType.macaddr);

  ///MAC (Media Access Control) address (EUI-64 format)
  TableColumnDefinition macaddr8(String name) =>
      _build(name, ColumnType.macaddr8);

  ///currency amount
  TableColumnDefinition money(String name) => _build(name, ColumnType.money);

  ///exact numeric of selectable precision
  TableColumnDefinition numeric(String name, int p, int s) =>
      _build(name, ColumnType.numeric, parameters: ['$p', '$s']);

  ///exact numeric of selectable precision
  TableColumnDefinition decimal(String name, int p, int s) =>
      _build(name, ColumnType.decimal, parameters: ['$p', '$s']);

  ///geometric path on a plane
  TableColumnDefinition path(String name) => _build(name, ColumnType.path);

  ///PostgreSQL Log Sequence Number
  TableColumnDefinition pgLsn(String name) => _build(name, ColumnType.pgLsn);

  ///user-level transaction ID snapshot
  TableColumnDefinition pgSnapshot(String name) =>
      _build(name, ColumnType.pgSnapshot);

  ///geometric point on a plane
  TableColumnDefinition point(String name) => _build(name, ColumnType.point);

  ///geometric polygon on a plane
  TableColumnDefinition polygon(String name) =>
      _build(name, ColumnType.polygon);

  ///single precision floating-point number (4 bytes)
  TableColumnDefinition real(String name) => _build(name, ColumnType.real);

  ///single precision floating-point number (4 bytes)
  TableColumnDefinition float4(String name) => _build(name, ColumnType.float4);

  ///signed two-byte integer
  TableColumnDefinition smallint(String name) =>
      _build(name, ColumnType.smallint);

  ///signed two-byte integer
  TableColumnDefinition int2(String name) => _build(name, ColumnType.int2);

  ///autoincrementing two-byte integer
  TableColumnDefinition smallserial(String name) =>
      _build(name, ColumnType.smallserial);

  ///autoincrementing two-byte integer
  TableColumnDefinition serial2(String name) =>
      _build(name, ColumnType.serial2);

  ///autoincrementing four-byte integer
  TableColumnDefinition serial(String name) => _build(name, ColumnType.serial);

  ///autoincrementing four-byte integer
  TableColumnDefinition serial4(String name) =>
      _build(name, ColumnType.serial4);

  ///variable-length character string
  TableColumnDefinition text(String name) => _build(name, ColumnType.text);

  ///time of day (no time zone)
  TableColumnDefinition time(String name, int p) =>
      _build(name, ColumnType.time, parameters: ['$p']);

  ///time of day (no time zone)
  TableColumnDefinition timeWithoutTimeZone(String name, int p) =>
      _build(name, ColumnType.timeWithoutTimeZone, parameters: ['$p']);

  ///time of day, including time zone
  TableColumnDefinition timeWithTimeZone(String name, int p) =>
      _build(name, ColumnType.timeWithTimeZone, parameters: ['$p']);

  ///time of day, including time zone
  TableColumnDefinition timetz(String name, int p) =>
      _build(name, ColumnType.timetz, parameters: ['$p']);

  ///date and time (no time zone)
  TableColumnDefinition timestamp(String name, int p) =>
      _build(name, ColumnType.timestamp, parameters: ['$p']);

  ///date and time (no time zone)
  TableColumnDefinition timestampWithoutTimeZone(String name, int p) =>
      _build(name, ColumnType.timestampWithoutTimeZone, parameters: ['$p']);

  ///date and time, including time zone
  TableColumnDefinition timestampWithTimeZone(String name, int p) =>
      _build(name, ColumnType.timestampWithTimeZone, parameters: ['$p']);

  ///date and time, including time zone
  TableColumnDefinition timestamptz(String name) =>
      _build(name, ColumnType.timestamptz);

  ///text search query
  TableColumnDefinition tsquery(String name) =>
      _build(name, ColumnType.tsquery);

  ///text search document
  TableColumnDefinition tsvector(String name) =>
      _build(name, ColumnType.tsvector);

  ///user-level transaction ID snapshot (deprecated; see pg_snapshot)
  TableColumnDefinition txidSnapshot(String name) =>
      _build(name, ColumnType.txidSnapshot);

  ///universally unique identifier
  TableColumnDefinition uuid(String name) => _build(name, ColumnType.uuid);

  ///XML data
  TableColumnDefinition xml(String name) => _build(name, ColumnType.xml);
}

class TableColumnDefinition extends TablePosibleAddition {
  final String _name;
  final ColumnType _type;
  final String? _compression;
  final String? _collate;
  final List<ColumnConstrains> _constraints;
  final List<String>? _parameters;
  TableColumnDefinition._(
    this._name,
    this._type, {
    String? compression,
    String? collate,
    List<ColumnConstrains>? constraints,
    List<String>? parameters,
  })  : _compression = compression,
        _collate = collate,
        _constraints = constraints ?? const <ColumnConstrains>[],
        _parameters = parameters;

  TableColumnDefinition notNull({String? name}) {
    return _copyWith(
        constraints: [..._constraints, NotNullContraint(name: name)]);
  }

  TableColumnDefinition primaryKey({String? name}) {
    return _copyWith(
        constraints: [..._constraints, PrimaryKeyContraint(name: name)]);
  }

  TableColumnDefinition unique({String? name, bool? nullsNotDistinct}) {
    return _copyWith(constraints: [
      ..._constraints,
      UniqueContraint(name: name, nullsNotDistinct: nullsNotDistinct)
    ]);
  }

  TableColumnDefinition check(String expression, {String? name}) {
    return _copyWith(
        constraints: [..._constraints, CheckContraint(expression, name: name)]);
  }

  TableColumnDefinition references(String tableName,
      {String? name,
      String? column,
      ReferencialAction Function(ReferencialActionRuleBuilder)? on}) {
    return _copyWith(constraints: [
      ..._constraints,
      ReferencesContraint(name: name, column: column, table: tableName, on: on)
    ]);
  }

  TableColumnDefinition defaultTo(String value) {
    return _copyWith(constraints: [
      ..._constraints,
      DefaultContraint(value),
    ]);
  }

  TableColumnDefinition collate(String collate) {
    return _copyWith(collate: collate);
  }

  TableColumnDefinition compression(String compression) {
    return _copyWith(compression: compression);
  }

  QueryString typeParameters() => QueryString().keyword(_type.type).condition(
      _parameters != null && _parameters!.isNotEmpty,
      (q) => q.parentesis((q) =>
          q.comaSeparated(_parameters!.map((e) => QueryString.user(e)))));
  @override
  QueryString build() => QueryString()
      .column(_name)
      .space()
      .adding(typeParameters())
      .condition(_compression != null,
          (q) => q.space().keyword('COMPRESSION').userInput(' $_compression'))
      .condition(_collate != null,
          (q) => q.space().keyword('COLLATE').userInput(' $_collate'))
      .condition(_constraints.isNotEmpty,
          (q) => q.space().join(_constraints, QueryString().space()));

  TableColumnDefinition _copyWith({
    String? name,
    ColumnType? type,
    String? compression,
    String? collate,
    List<ColumnConstrains>? constraints,
    List<String>? parameters,
  }) {
    return TableColumnDefinition._(
      name ?? _name,
      type ?? _type,
      compression: compression ?? _compression,
      collate: collate ?? _collate,
      constraints: constraints ?? _constraints,
      parameters: parameters ?? _parameters,
    );
  }
}
