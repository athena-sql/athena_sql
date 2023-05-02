library mysql1.test.test_infrastructure;

// import 'package:options_file/options_file.dart';
// import 'package:mysql1/mysql1.dart';
import 'package:athena_mysql/athena_mysql.dart';
import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';


AthenaMySql get conn => _conn!;
AthenaMySql? _conn;

void useConnection([String? tableName, String? createSql, String? insertSql]) {
  final db = 'testdb';

  final config = MySqlDatabaseConfig(
        '127.0.0.1', 3306,
        userName: 'root', password: '', databaseName: db, maxConnections: 10);

  setUp(() async {
    // Ensure db exists
    final c = config.copyWithDatabase(null);
    final a = AthenaMySql(c);
    await a.open();
    await a.driver.execute('DROP DATABASE IF EXISTS $db');
    await a.driver.execute('CREATE DATABASE $db CHARACTER SET utf8');
    await a.close();
    
    _conn = AthenaMySql(config);
    await _conn!.open();
  });

  tearDown(() async {
    await _conn?.driver.execute('DROP DATABASE IF EXISTS $db');
    await _conn?.close();
  });

}

