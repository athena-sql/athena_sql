part of 'builders.dart';

abstract class AthenaDriver {
  const AthenaDriver();
}

abstract class AthenaDatabaseTransactionDriver extends AthenaDriver {
  const AthenaDatabaseTransactionDriver();
}

abstract class AthenaDatabaseDriver extends AthenaDriver {
  const AthenaDatabaseDriver();

  Future<int> execute(String query);
  Future<bool> tableExists(String table);
}

abstract class AthenaDatabaseConnectionDriver extends AthenaDatabaseDriver {
  const AthenaDatabaseConnectionDriver();

  Future<void> open();

  Future<T> transaction<T>(Future<T> Function(AthenaDatabaseDriver driver) trx);
}

abstract class AthenaStringDriver extends AthenaDriver {
  const AthenaStringDriver();
}
