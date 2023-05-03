part of 'builders.dart';

abstract class AthenaDriver {
  const AthenaDriver();
  AthenaColumnsDriver get columns;
}

abstract class AthenaDatabaseTransactionDriver extends AthenaDatabaseDriver {
  const AthenaDatabaseTransactionDriver();
}
class ColumnDef {
  final String type;
  final List<String> parameters;
  final List<String> posParameters;
  const ColumnDef(this.type, {this.parameters = const [], this.posParameters = const []});
}
abstract class AthenaColumnsDriver {
  ColumnDef string();
  ColumnDef boolean();
  ColumnDef integer();
}
abstract class AthenaDatabaseDriver extends AthenaDriver {
  const AthenaDatabaseDriver();

  Future<int> execute(
    String queryString, {
    Map<String, dynamic>? mapValues,
  });
  Future<bool> tableExists(String table);
  Future<AthenaQueryResponse> query(
    String queryString, {
    Map<String, dynamic>? mapValues,
  });

}

abstract class AthenaDatabaseConnectionDriver extends AthenaDatabaseDriver {
  Future<void> open();
  Future<void> close();

  Future<T> transaction<T>(Future<T> Function(AthenaDatabaseDriver driver) trx);
}

abstract class AthenaStringDriver extends AthenaDriver {
  const AthenaStringDriver();
}
