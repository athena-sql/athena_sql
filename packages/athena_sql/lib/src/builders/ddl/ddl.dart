part of '../builders.dart';

class CreateBuilder<D extends AthenaDriver> {
  final D _driver;
  CreateBuilder(this._driver);

  AthenaQueryBuilder<D, CreateTableSchema> table(String name) {
    return AthenaQueryBuilder<D, CreateTableSchema>(
        _driver, CreateTableSchema(name));
  }
}

class DropBuilder<D extends AthenaDriver> {
  final D driver;
  const DropBuilder(this.driver);

  AthenaQueryBuilder<D, DropTableSchema> table(String name) =>
      AthenaQueryBuilder(driver, DropTableSchema(names: [name]));
}