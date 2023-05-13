import 'package:athena_mysql/src/mapper.dart';
import 'package:athena_sql/athena_sql.dart';
import 'package:mysql_client/mysql_client.dart';

import 'database_config.dart';

abstract class AthenaMySQLException implements Exception {
  final String message;

  const AthenaMySQLException(this.message);

  String get _prefix;

  @override
  String toString() {
    return '$_prefix: $message';
  }
}

class AthenaMySQLNoConnectionException extends AthenaMySQLException {
  const AthenaMySQLNoConnectionException(
      [super.message = "No connection found"]);

  @override
  String get _prefix => 'AthenaMySQLConnectionException';
}

class MySqlTransactionSQLDriver extends AthenaDatabaseDriver {
  MySQLConnection? connection;
  bool _isOpen = false;
  MySqlTransactionSQLDriver._connection(this.connection);

  @override
  Future<bool> tableExists(String table, {String? schema}) async {
    if (connection == null) throw AthenaMySQLNoConnectionException();
    var querySchema = schema;
    if (querySchema == null) {
      final result = await connection!.execute('SELECT DATABASE();');
      final newChema = result.rows.first
          .typedColAt<String>(0); //rows.first.typedColAt<String>(0);
      if (newChema != null) querySchema = newChema;
    }

    final result = await connection!.execute('''
          SELECT EXISTS (
            SELECT 
                TABLE_NAME
            FROM 
            information_schema.TABLES 
            WHERE 
                ${querySchema != null ? 'TABLE_SCHEMA = :schema AND' : ''}
                TABLE_TYPE LIKE 'BASE TABLE' AND
                TABLE_NAME = :table
            );
      ''', {'schema': querySchema, 'table': table});
    return result.rows.first.typedColAt<int>(0) == 1;
  }

  @override
  Future<AthenaQueryResponse> query(
    String queryString, {
    Map<String, dynamic>? mapValues,
    bool? iterable,
  }) async {
    if (connection == null) throw AthenaMySQLNoConnectionException();

    final mapper = QueryMapper(numered: false, prefixQuery: '?');

    final queryToExecute = mapper.getValues(queryString, mapValues ?? {});
    if (queryToExecute.args.isEmpty) {
      final result = await connection!.execute(queryToExecute.query);
      final mapped = result.rows.map((e) => QueryRow(e.typedAssoc())).toList();
      return QueryResponse(mapped);
    }
    final prepared =
        await connection!.prepare(queryToExecute.query, iterable ?? true);

    final result = await prepared.execute(queryToExecute.args);

    final mapped = result.rows.map((e) => QueryRow(e.typedAssoc())).toList();
    return QueryResponse(mapped);
  }

  @override
  Future<int> execute(
    String queryString, {
    Map<String, dynamic>? mapValues,
    bool? iterable,
  }) async {
    if (connection == null) throw AthenaMySQLNoConnectionException();

    final mapper = QueryMapper(numered: false, prefixQuery: '?');

    final queryToExecute = mapper.getValues(queryString, mapValues ?? {});
    if (queryToExecute.args.isEmpty) {
      final result = await connection!.execute(queryToExecute.query);
      return result.affectedRows.toInt();
    }
    final prepared =
        await connection!.prepare(queryToExecute.query, iterable ?? false);

    final result = await prepared.execute(queryToExecute.args);

    return result.affectedRows.toInt();
  }

  @override
  AthenaColumnsDriver get columns => MySqlColumnsDriver();

  @override
  String mapColumnOrTable(String column) {
    return column;
  }
}

class MySqlColumnsDriver extends AthenaColumnsDriver {
  @override
  ColumnDef boolean() => ColumnDef('BOOLEAN');

  @override
  ColumnDef integer() => ColumnDef('INTEGER');

  @override
  ColumnDef string() => ColumnDef('VARCHAR', parameters: ['255']);
}

class MySqlDriver extends MySqlTransactionSQLDriver
    implements AthenaDatabaseConnectionDriver {
  final MySqlDatabaseConfig _config;

  MySqlDriver(this._config) : super._connection(null);

  @override
  Future<void> open() async {
    if (_isOpen) return;
    connection ??= await _config.getConnection();

    await connection!.connect(timeoutMs: _config.timeoutMs);
    _isOpen = true;
  }

  @override
  Future<void> close() async {
    if (!_isOpen) return;
    await connection?.close();
    _isOpen = false;
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) {
    if (connection == null) throw AthenaMySQLNoConnectionException();
    return connection!.transactional((conn) {
      return trx(MySqlTransactionSQLDriver._connection(conn));
    });
  }
}

class AthenaMySQL extends AthenaSQL<MySqlDriver> {
  AthenaMySQL(MySqlDatabaseConfig config) : super(MySqlDriver(config));
  static Future<AthenaMySQL> fromMapConnection(
      Map<String, dynamic> connection) async {
    final config = MySqlDatabaseConfig.fromMap(connection);
    final athena = AthenaMySQL(config);
    await athena.open();
    return athena;
  }
}
