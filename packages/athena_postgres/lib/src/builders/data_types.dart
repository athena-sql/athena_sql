import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/schemas.dart';

class PostgresDataTypes {
  static const bigint = 'BIGINT';
  static const int8 = 'INT8';
  static const bigserial = 'BIGSERIAL';
  static const serial8 = 'SERIAL8';
  static const bit = 'BIT';
  static const bitVarying = 'BIT VARYING';
  static const varbit = 'VARBIT';
  static const boolean = 'BOOLEAN';
  static const bool = 'BOOL';
  static const box = 'BOX';
  static const bytea = 'BYTEA';
  static const character = 'CHARACTER';
  static const char = 'CHAR';
  static const characterVarying = 'CHARACTER VARYING';
  static const varchar = 'VARCHAR';
  static const cidr = 'CIDR';
  static const circle = 'CIRCLE';
  static const date = 'DATE';
  static const doublePrecision = 'DOUBLE PRECISION';
  static const float8 = 'FLOAT8';
  static const inet = 'INET';
  static const integer = 'INTEGER';
  static const int = 'INT';
  static const int4 = 'INT4';
  static const interval = 'INTERVAL';
  static const json = 'JSON';
  static const jsonb = 'JSONB';
  static const line = 'LINE';
  static const lseg = 'LSEG';
  static const macaddr = 'MACADDR';
  static const macaddr8 = 'MACADDR8';
  static const money = 'MONEY';
  static const numeric = 'NUMERIC';
  static const decimal = 'DECIMAL';
  static const path = 'PATH';
  static const pgLsn = 'PG_LSN';
  static const pgSnapshot = 'PG_SNAPSHOT';
  static const point = 'POINT';
  static const polygon = 'POLYGON';
  static const real = 'REAL';
  static const float4 = 'FLOAT4';
  static const smallint = 'SMALLINT';
  static const int2 = 'INT2';
  static const smallserial = 'SMALLSERIAL';
  static const serial2 = 'SERIAL2';
  static const serial = 'SERIAL';
  static const serial4 = 'SERIAL4';
  static const text = 'TEXT';
  static const time = 'TIME';
  static const timetz = 'TIMETZ';
  static const timestamp = 'TIMESTAMP';
  static const timestamptz = 'TIMESTAMPTZ';
  static const tsquery = 'TSQUERY';
  static const tsvector = 'TSVECTOR';
  static const txidSnapshot = 'TXID_SNAPSHOT';
  static const uuid = 'UUID';
  static const xml = 'XML';
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

enum TimeOption {
  withTimeZone('WITH TIME ZONE'),
  withoutTimeZone('WITHOUT TIME ZONE');

  final String value;
  const TimeOption(this.value);
}

extension ColumnBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  /// signed eight-byte integer
  ///
  /// *(alias: `int8`)*
  AthenaQueryBuilder<D, ColumnSchema> bigint(String name) =>
      $customType(name, type: PostgresDataTypes.bigint);

  /// signed eight-byte integer
  AthenaQueryBuilder<D, ColumnSchema> int8(String name) =>
      $customType(name, type: PostgresDataTypes.int8);

  /// autoincrementing eight-byte integer
  ///
  /// *(alias: `serial8`)*
  AthenaQueryBuilder<D, ColumnSchema> bigserial(String name) =>
      $customType(name, type: PostgresDataTypes.bigserial);

  /// autoincrementing eight-byte integer
  AthenaQueryBuilder<D, ColumnSchema> serial8(String name) =>
      $customType(name, type: PostgresDataTypes.serial8);

  /// fixed-length bit string
  AthenaQueryBuilder<D, ColumnSchema> bit(String name, int n) =>
      $customType(name, type: PostgresDataTypes.bit, parameters: ['$n']);

  /// variable-length bit string
  AthenaQueryBuilder<D, ColumnSchema> bitVarying(String name, int n) =>
      $customType(name, type: PostgresDataTypes.bitVarying, parameters: ['$n']);

  /// variable-length bit string
  AthenaQueryBuilder<D, ColumnSchema> varbit(String name, int n) =>
      $customType(name, type: PostgresDataTypes.varbit, parameters: ['$n']);

  /// logical Boolean (true/false)
  ///
  /// *(alias: `bool`)*
  AthenaQueryBuilder<D, ColumnSchema> boolean(String name) =>
      $customType(name, type: PostgresDataTypes.boolean);

  /// logical Boolean (true/false)
  AthenaQueryBuilder<D, ColumnSchema> bool(String name) =>
      $customType(name, type: PostgresDataTypes.bool);

  /// rectangular box on a plane
  AthenaQueryBuilder<D, ColumnSchema> box(String name) =>
      $customType(name, type: PostgresDataTypes.box);

  /// binary data (“byte array”)
  AthenaQueryBuilder<D, ColumnSchema> bytea(String name) =>
      $customType(name, type: PostgresDataTypes.bytea);

  /// **fixed-length character string**
  ///
  /// *(alias: char [ `(n)` ])*
  AthenaQueryBuilder<D, ColumnSchema> character(String name, int n) =>
      $customType(name, type: PostgresDataTypes.character, parameters: ['$n']);

  /// fixed-length character string
  AthenaQueryBuilder<D, ColumnSchema> char(String name, int n) =>
      $customType(name, type: PostgresDataTypes.char, parameters: ['$n']);

  /// variable-length character string
  ///
  /// *(alias: `varchar [ (n) ]`)*
  AthenaQueryBuilder<D, ColumnSchema> characterVarying(String name, int n) =>
      $customType(name,
          type: PostgresDataTypes.characterVarying, parameters: ['$n']);

  /// variable-length character string
  AthenaQueryBuilder<D, ColumnSchema> varchar(String name, int n) =>
      $customType(name, type: PostgresDataTypes.varchar, parameters: ['$n']);

  ///IPv4 or IPv6 network address
  AthenaQueryBuilder<D, ColumnSchema> cidr(String name) =>
      $customType(name, type: PostgresDataTypes.cidr);

  ///circle on a plane
  AthenaQueryBuilder<D, ColumnSchema> circle(String name) =>
      $customType(name, type: PostgresDataTypes.circle);

  ///calendar date (year, month, day)
  AthenaQueryBuilder<D, ColumnSchema> date(String name) =>
      $customType(name, type: PostgresDataTypes.date);

  ///double precision floating-point number (8 bytes)
  ///
  ///*(alias: `float8`)*
  AthenaQueryBuilder<D, ColumnSchema> doublePrecision(String name) =>
      $customType(name, type: PostgresDataTypes.doublePrecision);

  ///double precision floating-point number (8 bytes)
  AthenaQueryBuilder<D, ColumnSchema> float8(String name) =>
      $customType(name, type: PostgresDataTypes.float8);

  ///IPv4 or IPv6 host address
  AthenaQueryBuilder<D, ColumnSchema> inet(String name) =>
      $customType(name, type: PostgresDataTypes.inet);

  ///signed four-byte integer
  ///
  ///*(alias: `int`, `int4`)*
  AthenaQueryBuilder<D, ColumnSchema> integer(String name) =>
      $customType(name, type: PostgresDataTypes.integer);

  ///signed four-byte integer
  AthenaQueryBuilder<D, ColumnSchema> int_(String name) =>
      $customType(name, type: PostgresDataTypes.int);

  ///signed four-byte integer
  AthenaQueryBuilder<D, ColumnSchema> int4(String name) =>
      $customType(name, type: PostgresDataTypes.int4);

  ///time span
  AthenaQueryBuilder<D, ColumnSchema> interval(String name,
      [IntervalPhrases? fields, int? p]) {
    String? parameter;
    if (fields != null) {
      parameter = '${fields.name}${p != null ? '($p)' : ''}';
    }
    final posParameters = <String>[];
    if (parameter != null) {
      posParameters.add(parameter);
    }

    return $customType(name,
        type: PostgresDataTypes.interval, posParameters: posParameters);
  }

  ///JSON data
  AthenaQueryBuilder<D, ColumnSchema> json(String name) =>
      $customType(name, type: PostgresDataTypes.json);

  ///binary JSON data, decomposed
  AthenaQueryBuilder<D, ColumnSchema> jsonb(String name) =>
      $customType(name, type: PostgresDataTypes.jsonb);

  ///infinite line on a plane
  AthenaQueryBuilder<D, ColumnSchema> line(String name) =>
      $customType(name, type: PostgresDataTypes.line);

  ///line segment on a plane
  AthenaQueryBuilder<D, ColumnSchema> lseg(String name) =>
      $customType(name, type: PostgresDataTypes.lseg);

  ///MAC (Media Access Control) address
  AthenaQueryBuilder<D, ColumnSchema> macaddr(String name) =>
      $customType(name, type: PostgresDataTypes.macaddr);

  ///MAC (Media Access Control) address (EUI-64 format)
  AthenaQueryBuilder<D, ColumnSchema> macaddr8(String name) =>
      $customType(name, type: PostgresDataTypes.macaddr8);

  ///currency amount
  AthenaQueryBuilder<D, ColumnSchema> money(String name) =>
      $customType(name, type: PostgresDataTypes.money);

  ///exact numeric of selectable precision
  AthenaQueryBuilder<D, ColumnSchema> numeric(String name, int p, int s) =>
      $customType(name,
          type: PostgresDataTypes.numeric, parameters: ['$p', '$s']);

  ///exact numeric of selectable precision
  AthenaQueryBuilder<D, ColumnSchema> decimal(String name, int p, int s) =>
      $customType(name,
          type: PostgresDataTypes.decimal, parameters: ['$p', '$s']);

  ///geometric path on a plane
  AthenaQueryBuilder<D, ColumnSchema> path(String name) =>
      $customType(name, type: PostgresDataTypes.path);

  ///PostgreSQL Log Sequence Number
  AthenaQueryBuilder<D, ColumnSchema> pgLsn(String name) =>
      $customType(name, type: PostgresDataTypes.pgLsn);

  ///user-level transaction ID snapshot
  AthenaQueryBuilder<D, ColumnSchema> pgSnapshot(String name) =>
      $customType(name, type: PostgresDataTypes.pgSnapshot);

  ///geometric point on a plane
  AthenaQueryBuilder<D, ColumnSchema> point(String name) =>
      $customType(name, type: PostgresDataTypes.point);

  ///geometric polygon on a plane
  AthenaQueryBuilder<D, ColumnSchema> polygon(String name) =>
      $customType(name, type: PostgresDataTypes.polygon);

  ///single precision floating-point number (4 bytes)
  AthenaQueryBuilder<D, ColumnSchema> real(String name) =>
      $customType(name, type: PostgresDataTypes.real);

  ///single precision floating-point number (4 bytes)
  AthenaQueryBuilder<D, ColumnSchema> float4(String name) =>
      $customType(name, type: PostgresDataTypes.float4);

  ///signed two-byte integer
  AthenaQueryBuilder<D, ColumnSchema> smallint(String name) =>
      $customType(name, type: PostgresDataTypes.smallint);

  ///signed two-byte integer
  AthenaQueryBuilder<D, ColumnSchema> int2(String name) =>
      $customType(name, type: PostgresDataTypes.int2);

  ///autoincrementing two-byte integer
  AthenaQueryBuilder<D, ColumnSchema> smallserial(String name) =>
      $customType(name, type: PostgresDataTypes.smallserial);

  ///autoincrementing two-byte integer
  AthenaQueryBuilder<D, ColumnSchema> serial2(String name) =>
      $customType(name, type: PostgresDataTypes.serial2);

  ///autoincrementing four-byte integer
  AthenaQueryBuilder<D, ColumnSchema> serial(String name) =>
      $customType(name, type: PostgresDataTypes.serial);

  ///autoincrementing four-byte integer
  AthenaQueryBuilder<D, ColumnSchema> serial4(String name) =>
      $customType(name, type: PostgresDataTypes.serial4);

  ///variable-length character string
  AthenaQueryBuilder<D, ColumnSchema> text(String name) =>
      $customType(name, type: PostgresDataTypes.text);

  ///time of day (no time zone)
  AthenaQueryBuilder<D, ColumnSchema> time(String name, {int? p, TimeOption? option}) =>
      $customType(name, type: PostgresDataTypes.time, parameters: p != null ? ['$p'] : null, posParameters: option != null ? [option.value]: null);

  ///time of day, including time zone
  AthenaQueryBuilder<D, ColumnSchema> timetz(String name, {int? p}) =>
      $customType(name, type: PostgresDataTypes.timetz, parameters: p != null ? ['$p'] : null);

  ///date and time
  AthenaQueryBuilder<D, ColumnSchema> timestamp(String name, {int? p, TimeOption? option}) =>
      $customType(name, type: PostgresDataTypes.timestamp, parameters: p != null ? ['$p'] : null, posParameters: option != null ? [option.value]: null);

  ///date and time, including time zone
  AthenaQueryBuilder<D, ColumnSchema> timestamptz(String name) =>
      $customType(name, type: PostgresDataTypes.timestamptz);

  ///text search query
  AthenaQueryBuilder<D, ColumnSchema> tsquery(String name) =>
      $customType(name, type: PostgresDataTypes.tsquery);

  ///text search document
  AthenaQueryBuilder<D, ColumnSchema> tsvector(String name) =>
      $customType(name, type: PostgresDataTypes.tsvector);

  ///user-level transaction ID snapshot (deprecated; see pg_snapshot)
  AthenaQueryBuilder<D, ColumnSchema> txidSnapshot(String name) =>
      $customType(name, type: PostgresDataTypes.txidSnapshot);

  ///universally unique identifier
  AthenaQueryBuilder<D, ColumnSchema> uuid(String name) =>
      $customType(name, type: PostgresDataTypes.uuid);

  ///XML data
  AthenaQueryBuilder<D, ColumnSchema> xml(String name) =>
      $customType(name, type: PostgresDataTypes.xml);
}
