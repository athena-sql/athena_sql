import 'package:athena_sql/src/builders/builders.dart';

class TestDriver extends AthenaStringDriver {}

class TestDatabaseTransactionDriver extends AthenaDatabaseTransactionDriver {
  @override
  Future<int> execute(String query) {
    return Future.value(0);
  }

  @override
  Future<bool> tableExists(String table) {
    return Future.value(false);
  }
}

class TestDatabaseDriver extends AthenaDatabaseConnectionDriver {
  final Function(String) executable;
  TestDatabaseDriver(this.executable);
  @override
  Future<int> execute(String query) {
    return Future.value(0);
  }

  @override
  Future<bool> tableExists(String table) {
    return Future.value(false);
  }

  @override
  Future<void> open() {
    return Future.value();
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) {
    return trx(TestDatabaseTransactionDriver());
  }
}

String normalizeSql(String sql) {
  return sql
      .replaceAll(
          RegExp(r'\s+'), ' ') // Replace multiple spaces with a single space
      .replaceAll('\n', ' ') // Remove line breaks
      .trim(); // Remove leading and trailing spaces
}
