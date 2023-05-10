part of 'builders.dart';

class AthenaQueryBuilder<D extends AthenaDriver, B extends QueryBuilder> {
  final B $schema;
  final D _driver;
  const AthenaQueryBuilder(this._driver, this.$schema);

  AthenaQueryBuilder<D, B> _copyWith({
    B? schema,
    D? driver,
  }) =>
      AthenaQueryBuilder(
        driver ?? this._driver,
        schema ?? this.$schema,
      );
  AthenaQueryBuilder<ND, B> changeDriver<ND extends AthenaDriver>(
    ND driver,
  ) =>
      AthenaQueryBuilder(
        driver,
        this.$schema,
      );
  AthenaQueryBuilder<D, NB> _changeBuilder<NB extends QueryBuilder>(
    NB schema,
  ) =>
      AthenaQueryBuilder(
        this._driver,
        schema,
      );
}

typedef QueryRows = List<Map<String, Map<String, dynamic>>>;

extension AthenaDDLQueryExtension<D extends AthenaDatabaseDriver>
    on AthenaQueryBuilder<D, DdlSchema> {
  Future<int> run() => _driver.execute($schema.plain());
}

extension AthenaInsertTableQueryExtension<D extends AthenaDatabaseDriver>
    on AthenaQueryBuilder<D, InsertTableSchema> {
  Future<int> run() => _driver
      .query($schema.plain(), mapValues: $mappedValues())
      .then((value) => value.affectedRows);
}

extension AthenaInseretTableQueryExtension<D extends AthenaDatabaseDriver>
    on AthenaQueryBuilder<D, SelectTableSchema> {
  Future<AthenaQueryResponse> run({Map<String, dynamic>? mapValues}) =>
      _driver.query($schema.plain(), mapValues: mapValues);
}

extension AthenaStringExtension<D extends AthenaStringDriver,
    B extends QueryBuilder> on AthenaQueryBuilder<D, B> {
  String build() => $schema.plain();
}
