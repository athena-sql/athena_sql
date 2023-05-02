import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/schemas.dart';

extension IntegerDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> tinyint(String name) =>
      $customType(name, type: 'TINYINT');

  AthenaQueryBuilder<D, ColumnSchema> smallint(String name) =>
      $customType(name, type: 'SMALLINT');

  AthenaQueryBuilder<D, ColumnSchema> mediumint(String name) =>
      $customType(name, type: "MEDIUMINT");

  AthenaQueryBuilder<D, ColumnSchema> int_(String name) =>
      $customType(name, type: "INT");

  AthenaQueryBuilder<D, ColumnSchema> _fixedPointType(String name, String type,
      [int? digits, int? decimals]) {
    assert(digits == null || digits > 0);
    assert(digits == null || digits < 65);
    assert(decimals == null || decimals > 0);
    // assert if decimals is not null, digits must be not null
    assert(digits != null || decimals == null);
    return $customType(name,
        type: type, parameters: ['$digits', if (decimals != null) '$decimals']);
  }

  AthenaQueryBuilder<D, ColumnSchema> decimal(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DECIMAL', digits, decimals);

  AthenaQueryBuilder<D, ColumnSchema> numeric(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'NUMERIC', digits, decimals);
}

extension FixedPointDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> _fixedPointType(String name, String type,
      [int? digits, int? decimals]) {
    assert(digits == null || digits > 0);
    assert(digits == null || digits < 65);
    assert(decimals == null || decimals > 0);
    // assert if decimals is not null, digits must be not null
    assert(digits != null || decimals == null);
    return $customType(name, type: type, parameters: [
      if (digits != null) '$digits',
      if (digits != null && decimals != null) '$decimals'
    ]);
  }

  AthenaQueryBuilder<D, ColumnSchema> decimal(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DECIMAL', digits, decimals);

  AthenaQueryBuilder<D, ColumnSchema> numeric(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'NUMERIC', digits, decimals);

  AthenaQueryBuilder<D, ColumnSchema> dec(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DEC', digits, decimals);

  AthenaQueryBuilder<D, ColumnSchema> fixed(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'FIXED', digits, decimals);
}

extension FloatingPointDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> _floatingPointType(
      String name, String type,
      [int? precision, int? decimals]) {
    assert(precision == null || precision > 0);
    assert(precision == null || precision < 53);
    assert(decimals == null || decimals > 0);
    // assert if decimals is not null, digits must be not null
    assert(precision != null || decimals == null);
    return $customType(name, type: type, parameters: [
      if (precision != null) '$precision',
      if (precision != null && decimals != null) '$decimals'
    ]);
  }

  AthenaQueryBuilder<D, ColumnSchema> float(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'FLOAT', precision, decimals);

  AthenaQueryBuilder<D, ColumnSchema> double(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'DOUBLE', precision, decimals);

  AthenaQueryBuilder<D, ColumnSchema> doublePrecision(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'DOUBLE PRECISION', precision, decimals);
}

extension BitValueDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> bit(String name, int values) {
    assert(values >= 1 || values <= 64);
    return $customType(name, type: 'BIT', parameters: ['$values']);
  }
}
