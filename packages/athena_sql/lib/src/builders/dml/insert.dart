part of '../builders.dart';

extension SelectTableBuildear<D extends AthenaDriver>
    on AthenaQueryBuilder<D, InsertTableSchema> {
  AthenaQueryBuilder<D, InsertTableSchema> values(Map<String, dynamic> values) {
    return _changeBuilder($schema.copyWithAddValues(values));
  }
}
