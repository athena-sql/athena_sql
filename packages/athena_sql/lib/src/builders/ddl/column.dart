part of '../builders.dart';


extension ColumnBuilder<D extends AthenaDriver> on AthenaQueryBuilder<D,CreateColumnSchema> {
  AthenaQueryBuilder<D,ColumnSchema> _build(String name, ColumnType type,
      {List<String>? parameters}) => _changeBuilder(ColumnSchema(name, type, parameters: parameters));

  /// signed eight-byte integer
  ///
  /// *(alias: `int8`)*
  AthenaQueryBuilder<D,ColumnSchema> bigint(String name) => _build(name, ColumnType.bigint);

  /// signed eight-byte integer
  AthenaQueryBuilder<D,ColumnSchema> int8(String name) => _build(name, ColumnType.int8);

  /// autoincrementing eight-byte integer
  ///
  /// *(alias: `serial8`)*
  AthenaQueryBuilder<D,ColumnSchema> bigserial(String name) =>
      _build(name, ColumnType.bigserial);

  /// autoincrementing eight-byte integer
  AthenaQueryBuilder<D,ColumnSchema> serial8(String name) =>
      _build(name, ColumnType.serial8);

  /// fixed-length bit string
  AthenaQueryBuilder<D,ColumnSchema> bit(String name, int n) =>
      _build(name, ColumnType.bit, parameters: ['$n']);

  /// variable-length bit string
  AthenaQueryBuilder<D,ColumnSchema> bitVarying(String name, int n) =>
      _build(name, ColumnType.bitVarying, parameters: ['$n']);

  /// variable-length bit string
  AthenaQueryBuilder<D,ColumnSchema> varbit(String name, int n) =>
      _build(name, ColumnType.varbit, parameters: ['$n']);

  /// logical Boolean (true/false)
  ///
  /// *(alias: `bool`)*
  AthenaQueryBuilder<D,ColumnSchema> boolean(String name) =>
      _build(name, ColumnType.boolean);

  /// logical Boolean (true/false)
  AthenaQueryBuilder<D,ColumnSchema> bool(String name) => _build(name, ColumnType.bool);

  /// rectangular box on a plane
  AthenaQueryBuilder<D,ColumnSchema> box(String name) => _build(name, ColumnType.box);

  /// binary data (“byte array”)
  AthenaQueryBuilder<D,ColumnSchema> bytea(String name) => _build(name, ColumnType.bytea);

  /// **fixed-length character string**
  ///
  /// *(alias: char [ `(n)` ])*
  AthenaQueryBuilder<D,ColumnSchema> character(String name, int n) =>
      _build(name, ColumnType.character, parameters: ['$n']);

  /// fixed-length character string
  AthenaQueryBuilder<D,ColumnSchema> char(String name, int n) =>
      _build(name, ColumnType.char, parameters: ['$n']);

  /// variable-length character string
  ///
  /// *(alias: `varchar [ (n) ]`)*
  AthenaQueryBuilder<D,ColumnSchema> characterVarying(String name, int n) =>
      _build(name, ColumnType.characterVarying, parameters: ['$n']);

  /// variable-length character string
  AthenaQueryBuilder<D,ColumnSchema> varchar(String name, int n) =>
      _build(name, ColumnType.varchar, parameters: ['$n']);

  ///IPv4 or IPv6 network address
  AthenaQueryBuilder<D,ColumnSchema> cidr(String name) => _build(name, ColumnType.cidr);

  ///circle on a plane
  AthenaQueryBuilder<D,ColumnSchema> circle(String name) => _build(name, ColumnType.circle);

  ///calendar date (year, month, day)
  AthenaQueryBuilder<D,ColumnSchema> date(String name) => _build(name, ColumnType.date);

  ///double precision floating-point number (8 bytes)
  ///
  ///*(alias: `float8`)*
  AthenaQueryBuilder<D,ColumnSchema> doublePrecision(String name) =>
      _build(name, ColumnType.doublePrecision);

  ///double precision floating-point number (8 bytes)
  AthenaQueryBuilder<D,ColumnSchema> float8(String name) => _build(name, ColumnType.float8);

  ///IPv4 or IPv6 host address
  AthenaQueryBuilder<D,ColumnSchema> inet(String name) => _build(name, ColumnType.inet);

  ///signed four-byte integer
  ///
  ///*(alias: `int`, `int4`)*
  AthenaQueryBuilder<D,ColumnSchema> integer(String name) =>
      _build(name, ColumnType.integer);

  ///signed four-byte integer
  AthenaQueryBuilder<D,ColumnSchema> int_(String name) => _build(name, ColumnType.int);

  ///signed four-byte integer
  AthenaQueryBuilder<D,ColumnSchema> int4(String name) => _build(name, ColumnType.int4);

  ///time span
  AthenaQueryBuilder<D,ColumnSchema> interval(String name, IntervalPhrases fields, int p) =>
      _build(name, ColumnType.interval, parameters: ['$fields', '$p']);

  ///JSON data
  AthenaQueryBuilder<D,ColumnSchema> json(String name) => _build(name, ColumnType.json);

  ///binary JSON data, decomposed
  AthenaQueryBuilder<D,ColumnSchema> jsonb(String name) => _build(name, ColumnType.jsonb);

  ///infinite line on a plane
  AthenaQueryBuilder<D,ColumnSchema> line(String name) => _build(name, ColumnType.line);

  ///line segment on a plane
  AthenaQueryBuilder<D,ColumnSchema> lseg(String name) => _build(name, ColumnType.lseg);

  ///MAC (Media Access Control) address
  AthenaQueryBuilder<D,ColumnSchema> macaddr(String name) =>
      _build(name, ColumnType.macaddr);

  ///MAC (Media Access Control) address (EUI-64 format)
  AthenaQueryBuilder<D,ColumnSchema> macaddr8(String name) =>
      _build(name, ColumnType.macaddr8);

  ///currency amount
  AthenaQueryBuilder<D,ColumnSchema> money(String name) => _build(name, ColumnType.money);

  ///exact numeric of selectable precision
  AthenaQueryBuilder<D,ColumnSchema> numeric(String name, int p, int s) =>
      _build(name, ColumnType.numeric, parameters: ['$p', '$s']);

  ///exact numeric of selectable precision
  AthenaQueryBuilder<D,ColumnSchema> decimal(String name, int p, int s) =>
      _build(name, ColumnType.decimal, parameters: ['$p', '$s']);

  ///geometric path on a plane
  AthenaQueryBuilder<D,ColumnSchema> path(String name) => _build(name, ColumnType.path);

  ///PostgreSQL Log Sequence Number
  AthenaQueryBuilder<D,ColumnSchema> pgLsn(String name) => _build(name, ColumnType.pgLsn);

  ///user-level transaction ID snapshot
  AthenaQueryBuilder<D,ColumnSchema> pgSnapshot(String name) =>
      _build(name, ColumnType.pgSnapshot);

  ///geometric point on a plane
  AthenaQueryBuilder<D,ColumnSchema> point(String name) => _build(name, ColumnType.point);

  ///geometric polygon on a plane
  AthenaQueryBuilder<D,ColumnSchema> polygon(String name) =>
      _build(name, ColumnType.polygon);

  ///single precision floating-point number (4 bytes)
  AthenaQueryBuilder<D,ColumnSchema> real(String name) => _build(name, ColumnType.real);

  ///single precision floating-point number (4 bytes)
  AthenaQueryBuilder<D,ColumnSchema> float4(String name) => _build(name, ColumnType.float4);

  ///signed two-byte integer
  AthenaQueryBuilder<D,ColumnSchema> smallint(String name) =>
      _build(name, ColumnType.smallint);

  ///signed two-byte integer
  AthenaQueryBuilder<D,ColumnSchema> int2(String name) => _build(name, ColumnType.int2);

  ///autoincrementing two-byte integer
  AthenaQueryBuilder<D,ColumnSchema> smallserial(String name) =>
      _build(name, ColumnType.smallserial);

  ///autoincrementing two-byte integer
  AthenaQueryBuilder<D,ColumnSchema> serial2(String name) =>
      _build(name, ColumnType.serial2);

  ///autoincrementing four-byte integer
  AthenaQueryBuilder<D,ColumnSchema> serial(String name) => _build(name, ColumnType.serial);

  ///autoincrementing four-byte integer
  AthenaQueryBuilder<D,ColumnSchema> serial4(String name) =>
      _build(name, ColumnType.serial4);

  ///variable-length character string
  AthenaQueryBuilder<D,ColumnSchema> text(String name) => _build(name, ColumnType.text);

  ///time of day (no time zone)
  AthenaQueryBuilder<D,ColumnSchema> time(String name, int p) =>
      _build(name, ColumnType.time, parameters: ['$p']);

  ///time of day (no time zone)
  AthenaQueryBuilder<D,ColumnSchema> timeWithoutTimeZone(String name, int p) =>
      _build(name, ColumnType.timeWithoutTimeZone, parameters: ['$p']);

  ///time of day, including time zone
  AthenaQueryBuilder<D,ColumnSchema> timeWithTimeZone(String name, int p) =>
      _build(name, ColumnType.timeWithTimeZone, parameters: ['$p']);

  ///time of day, including time zone
  AthenaQueryBuilder<D,ColumnSchema> timetz(String name, int p) =>
      _build(name, ColumnType.timetz, parameters: ['$p']);

  ///date and time (no time zone)
  AthenaQueryBuilder<D,ColumnSchema> timestamp(String name, int p) =>
      _build(name, ColumnType.timestamp, parameters: ['$p']);

  ///date and time (no time zone)
  AthenaQueryBuilder<D,ColumnSchema> timestampWithoutTimeZone(String name, int p) =>
      _build(name, ColumnType.timestampWithoutTimeZone, parameters: ['$p']);

  ///date and time, including time zone
  AthenaQueryBuilder<D,ColumnSchema> timestampWithTimeZone(String name, int p) =>
      _build(name, ColumnType.timestampWithTimeZone, parameters: ['$p']);

  ///date and time, including time zone
  AthenaQueryBuilder<D,ColumnSchema> timestamptz(String name) =>
      _build(name, ColumnType.timestamptz);

  ///text search query
  AthenaQueryBuilder<D,ColumnSchema> tsquery(String name) =>
      _build(name, ColumnType.tsquery);

  ///text search document
  AthenaQueryBuilder<D,ColumnSchema> tsvector(String name) =>
      _build(name, ColumnType.tsvector);

  ///user-level transaction ID snapshot (deprecated; see pg_snapshot)
  AthenaQueryBuilder<D,ColumnSchema> txidSnapshot(String name) =>
      _build(name, ColumnType.txidSnapshot);

  ///universally unique identifier
  AthenaQueryBuilder<D,ColumnSchema> uuid(String name) => _build(name, ColumnType.uuid);

  ///XML data
  AthenaQueryBuilder<D,ColumnSchema> xml(String name) => _build(name, ColumnType.xml);
}