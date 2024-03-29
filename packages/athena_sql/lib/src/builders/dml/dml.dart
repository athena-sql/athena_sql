part of '../builders.dart';

class SelectOptions<D extends AthenaDriver> {
  final D _driver;
  SelectOptions(this._driver);

  SelectTableOptions<D> call(List<String> columns) {
    return SelectTableOptions(
        _driver, [...columns.map((e) => _driver.mapColumnOrTable(e))]);
  }
}

class InsertOptions<D extends AthenaDriver> {
  final D _driver;
  InsertOptions(this._driver);

  InsertTableOptions<D> into(String name) {
    return InsertTableOptions(_driver, name);
  }
}

class InsertTableOptions<D extends AthenaDriver> {
  final D _driver;
  final String _name;
  const InsertTableOptions(this._driver, this._name);

  AthenaQueryBuilder<D, InsertTableSchema> values(Map<String, dynamic> values) {
    return AthenaQueryBuilder<D, InsertTableSchema>(
        _driver, InsertTableSchema(name: _name, listValues: [values]));
  }

  AthenaQueryBuilder<D, InsertTableSchema> manyValues(
      List<Map<String, dynamic>> listValues) {
    return AthenaQueryBuilder<D, InsertTableSchema>(
        _driver, InsertTableSchema(name: _name, listValues: listValues));
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
