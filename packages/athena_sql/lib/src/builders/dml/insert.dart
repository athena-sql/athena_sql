part of '../builders.dart';

extension InsertTableBuildear<D extends AthenaDriver>
    on AthenaQueryBuilder<D, InsertTableSchema> {
  AthenaQueryBuilder<D, InsertTableSchema> values(Map<String, dynamic> values) {
    return _changeBuilder($schema.copyWithAddValues(values));
  }

  Map<String, dynamic> $mappedValues() {
    return $schema.mapValues();
  }
}
