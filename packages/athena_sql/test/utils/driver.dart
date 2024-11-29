import 'package:athena_sql/src/builders/builders.dart';

class TestDriver extends AthenaStringDriver {
  @override
  AthenaColumnsDriver get columns => throw UnimplementedError();

  @override
  String mapColumnOrTable(String column) {
    return column;
  }
}

class TestDatabaseTransactionDriver extends AthenaDatabaseTransactionDriver {
  @override
  Future<bool> tableExists(String table) {
    return Future.value(false);
  }

  @override
  Future<AthenaQueryResponse> execute(String queryString,
      {Map<String, dynamic>? mapValues}) {
    throw UnimplementedError();
  }

  @override
  AthenaColumnsDriver get columns => throw UnimplementedError();

  @override
  String mapColumnOrTable(String column) {
    throw UnimplementedError();
  }
}

class TestDatabaseDriver extends AthenaDatabaseConnectionDriver {
  final Function(String) executable;
  TestDatabaseDriver(this.executable);

  @override
  Future<bool> tableExists(String table) {
    return Future.value(false);
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) {
    return trx(TestDatabaseTransactionDriver());
  }

  @override
  Future<AthenaQueryResponse> execute(String queryString,
      {Map<String, dynamic>? mapValues}) {
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    throw UnimplementedError();
  }

  @override
  AthenaColumnsDriver get columns => throw UnimplementedError();

  @override
  String mapColumnOrTable(String column) {
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
