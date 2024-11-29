library mysql1.test.test_infrastructure;

// import 'package:options_file/options_file.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:athena_mysql/athena_mysql.dart';
import 'package:test/test.dart';

AthenaMySQL get conn => _conn!;
AthenaMySQL? _conn;

void useConnection([String? tableName, String? createSql, String? insertSql]) {
  final db = 'testdb';

  final endpoint = AthenaMySqlEndpoint(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: '',
      databaseName: db);

  setUp(() async {
    // Ensure db exists
    final c = endpoint.copyWithDatabase(null);
    final a = await AthenaMySQL.open(c);
    await a.driver.execute('DROP DATABASE IF EXISTS $db');
    await a.driver.execute('CREATE DATABASE $db CHARACTER SET utf8');
    await a.close();

    _conn = await AthenaMySQL.open(endpoint);
  });

  tearDown(() async {
    await _conn?.driver.execute('DROP DATABASE IF EXISTS $db');
    await _conn?.close();
  });
}
