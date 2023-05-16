part of '../builders.dart';

extension SelectTableBuildear<D extends AthenaDriver>
    on AthenaQueryBuilder<D, WhereCreatorSchema> {
  WhereItemValue string(String value) {
    return WhereItemValue('\'$value\'');
  }

  WhereItemValue variable(String value) {
    return WhereItemValue('@$value');
  }

  WhereItemValue value(String val) {
    return WhereItemValue(_driver.mapColumnOrTable(val));
  }

  WhereItemValue operator [](String value) => this.value(value);
  WhereJoins and(WhereClause clasue1, WhereClause clause2) {
    return WhereJoins(clasue1, Operators.and, clause2);
  }

  WhereJoins or(WhereClause clasue1, WhereClause clause2) {
    return WhereJoins(clasue1, Operators.or, clause2);
  }
}

extension SelectTableBuilder<D extends AthenaDriver>
    on AthenaQueryBuilder<D, SelectTableSchema> {
  AthenaQueryBuilder<D, SelectTableSchema> as(String alias) {
    return _changeBuilder($schema.copyWith(as: alias));
  }

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
