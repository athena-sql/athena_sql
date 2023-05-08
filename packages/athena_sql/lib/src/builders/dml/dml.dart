part of '../builders.dart';

class SelectOptions<D extends AthenaDriver> {
  final D _driver;
  SelectOptions(this._driver);

  SelectTableOptions<D> call(List<String> columns) {
    return SelectTableOptions(_driver, columns);
  }
}

class SelectTableOptions<D extends AthenaDriver> {
  final D _driver;
  final List<String> _columns;
  const SelectTableOptions(this._driver, this._columns);

  AthenaQueryBuilder<D, SelectTableSchema> from(String name) {
    return AthenaQueryBuilder<D, SelectTableSchema>(
        _driver, SelectTableSchema(name, columns: _columns));
  }
}
