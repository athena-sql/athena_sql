part of '../builders.dart';

extension SelectTableBuildear<D extends AthenaDriver>
    on AthenaQueryBuilder<D, WhereCreatorSchema> {
  WhereItem string(String value) {
    return WhereItemValue('\'$value\'');
  }

  WhereItem variable(String value) {
    return WhereItemValue('@$value');
  }

  WhereItem value(String value) {
    return WhereItemValue(value);
  }

  WhereItem operator [](String value) => this.value(value);
  WhereClause and(WhereClause clasue1, WhereClause clause2) {
    return WhereJoins(clasue1, Operators.and, clause2);
  }

  WhereClause or(WhereClause clasue1, WhereClause clause2) {
    return WhereJoins(clasue1, Operators.or, clause2);
  }
}

extension SelectTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, SelectTableSchema> {
  AthenaQueryBuilder<D, SelectTableSchema> where(
    WhereClause Function(AthenaQueryBuilder<D, WhereCreatorSchema>) builder,
  ) {
    final clause = builder(_changeBuilder(WhereCreatorSchema()));
    if ($schema.where == null) {
      return _changeBuilder($schema.copyWith(where: clause));
    } else {
      return _changeBuilder($schema.copyWith(where: $schema.where! & clause));
    }
  }
}
