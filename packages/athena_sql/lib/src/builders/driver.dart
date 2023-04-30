part of 'builders.dart';

abstract class AthenaDriver {
  const AthenaDriver();
}

abstract class AthenaDatabaseTransactionDriver extends AthenaDatabaseDriver {
  const AthenaDatabaseTransactionDriver();
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
  const AthenaDatabaseConnectionDriver();

  Future<void> open();

  Future<T> transaction<T>(Future<T> Function(AthenaDatabaseDriver driver) trx);
}

abstract class AthenaStringDriver extends AthenaDriver {
  const AthenaStringDriver();
}
