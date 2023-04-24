import 'package:athena_sql/src/schemas/ddl/shared.dart';
import 'package:athena_sql/src/utils/query_string.dart';

import 'constraint.dart';

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
  final ColumnType _type;
  final String? _compression;
  final String? _collate;
  final List<ColumnConstrains> constraints;
  final List<String>? _parameters;
  ColumnSchema(
    this._name,
    this._type, {
    String? compression,
    String? collate,
    List<ColumnConstrains>? constraints,
    List<String>? parameters,
  })  : _compression = compression,
        _collate = collate,
        constraints = constraints ?? const <ColumnConstrains>[],
        _parameters = parameters;

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
      .condition(constraints.isNotEmpty,
          (q) => q.space().join(constraints, QueryString().space()));

  ColumnSchema copyWith({
    String? name,
    ColumnType? type,
    String? compression,
    String? collate,
    List<ColumnConstrains>? constraints,
    List<String>? parameters,
  }) {
    return ColumnSchema(
      name ?? _name,
      type ?? _type,
      compression: compression ?? _compression,
      collate: collate ?? _collate,
      constraints: constraints ?? constraints,
      parameters: parameters ?? _parameters,
    );
  }
}
