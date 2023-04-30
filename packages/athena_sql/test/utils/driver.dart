import 'package:athena_sql/src/builders/builders.dart';

class TestDriver extends AthenaStringDriver {}

class TestDatabaseTransactionDriver extends AthenaDatabaseTransactionDriver {
  @override
  Future<int> execute(String query, {Map<String, dynamic>? mapValues}) {
    return Future.value(0);
  }

  @override
  Future<bool> tableExists(String table) {
    return Future.value(false);
  }

  @override
  Future<AthenaQueryResponse> query(String queryString,
      {Map<String, dynamic>? mapValues}) {
    throw UnimplementedError();
  }
}

class TestDatabaseDriver extends AthenaDatabaseConnectionDriver {
  final Function(String) executable;
  TestDatabaseDriver(this.executable);
  @override
  Future<int> execute(String query, {Map<String, dynamic>? mapValues}) {
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

  @override
  Future<AthenaQueryResponse> query(String queryString,
      {Map<String, dynamic>? mapValues}) {
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    throw UnimplementedError();
  }
}

String normalizeSql(String sql) {
  return sql
      .replaceAll(
          RegExp(r'\s+'), ' ') // Replace multiple spaces with a single space
      .replaceAll('\n', ' ') // Remove line breaks
      .trim(); // Remove leading and trailing spaces
}
