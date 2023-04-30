part of '../builders.dart';

extension ColumnBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, CreateColumnSchema> {
  AthenaQueryBuilder<D, ColumnSchema> $customType(String name,
          {required String type, List<String>? parameters}) =>
      _changeBuilder(ColumnSchema(name, type, parameters: parameters));
}
