import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/schemas.dart';

/// Integer Data Types
extension IntegerDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  /// Create a column with type TINYINT
  AthenaQueryBuilder<D, ColumnSchema> tinyint(String name) =>
      $customType(name, type: 'TINYINT');

  /// Create a column with type SMALLINT
  AthenaQueryBuilder<D, ColumnSchema> smallint(String name) =>
      $customType(name, type: 'SMALLINT');

  /// Create a column with type MEDIUMINT
  AthenaQueryBuilder<D, ColumnSchema> mediumint(String name) =>
      $customType(name, type: 'MEDIUMINT');

  /// Create a column with type INT
  AthenaQueryBuilder<D, ColumnSchema> int_(String name) =>
      $customType(name, type: 'INT');

  AthenaQueryBuilder<D, ColumnSchema> _fixedPointType(String name, String type,
      [int? digits, int? decimals]) {
    assert(digits == null || digits > 0, 'digits must be greater than 0');
    assert(digits == null || digits < 65, 'digits must be less than 65');
    assert(decimals == null || decimals > 0, 'decimals must be greater than 0');
    // assert if decimals is not null, digits must be not null
    assert(digits != null || decimals == null,
        'digits must be not null if decimals is not null');
    return $customType(name,
        type: type, parameters: ['$digits', if (decimals != null) '$decimals']);
  }

  /// Create a column with type DECIMAL
  AthenaQueryBuilder<D, ColumnSchema> decimal(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DECIMAL', digits, decimals);

  /// Create a column with type NUMERIC
  AthenaQueryBuilder<D, ColumnSchema> numeric(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'NUMERIC', digits, decimals);
}

/// Floating Point Data Types
extension FixedPointDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> _fixedPointType(String name, String type,
      [int? digits, int? decimals]) {
    assert(digits == null || digits > 0, 'digits must be greater than 0');
    assert(digits == null || digits < 65, 'digits must be less than 65');
    assert(decimals == null || decimals > 0, 'decimals must be greater than 0');
    // assert if decimals is not null, digits must be not null
    assert(digits != null || decimals == null,
        'digits must be not null if decimals is not null');
    return $customType(name, type: type, parameters: [
      if (digits != null) '$digits',
      if (digits != null && decimals != null) '$decimals'
    ]);
  }

  /// Create a column with type DECIMAL
  AthenaQueryBuilder<D, ColumnSchema> decimal(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DECIMAL', digits, decimals);

  /// Create a column with type NUMERIC
  AthenaQueryBuilder<D, ColumnSchema> numeric(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'NUMERIC', digits, decimals);

  /// Create a column with type DEC
  AthenaQueryBuilder<D, ColumnSchema> dec(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'DEC', digits, decimals);

  /// Create a column with type FIXED
  AthenaQueryBuilder<D, ColumnSchema> fixed(String name,
          [int? digits, int? decimals]) =>
      _fixedPointType(name, 'FIXED', digits, decimals);
}

/// Floating Point Data Types
extension FloatingPointDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> _floatingPointType(
      String name, String type,
      [int? precision, int? decimals]) {
    assert(
        precision == null || precision > 0, 'precision must be greater than 0');
    assert(
        precision == null || precision < 53, 'precision must be less than 53');
    assert(decimals == null || decimals > 0, 'decimals must be greater than 0');
    // assert if decimals is not null, digits must be not null
    assert(precision != null || decimals == null,
        'precision must be not null if decimals is not null');
    return $customType(name, type: type, parameters: [
      if (precision != null) '$precision',
      if (precision != null && decimals != null) '$decimals'
    ]);
  }

  /// Create a column with type FLOAT
  AthenaQueryBuilder<D, ColumnSchema> float(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'FLOAT', precision, decimals);

  /// Create a column with type DOUBLE
  AthenaQueryBuilder<D, ColumnSchema> double(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'DOUBLE', precision, decimals);

  /// Create a column with type DOUBLE PRECISION
  AthenaQueryBuilder<D, ColumnSchema> doublePrecision(String name,
          [int? precision, int? decimals]) =>
      _floatingPointType(name, 'DOUBLE PRECISION', precision, decimals);
}

/// Bits Data Types
extension BitValueDataTypes<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  /// Create a column with type BIT
  AthenaQueryBuilder<D, ColumnSchema> bit(String name, int values) {
    assert(values >= 1 || values <= 64, 'values must be between 1 and 64');
    return $customType(name, type: 'BIT', parameters: ['$values']);
  }
}
