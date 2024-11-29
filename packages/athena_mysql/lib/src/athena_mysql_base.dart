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
  MySQLConnection connection;
  bool _isOpen = false;
  MySqlTransactionSQLDriver._(this.connection);

  static Future<MySqlTransactionSQLDriver> open(
      AthenaMySqlEndpoint endpoint) async {
    final connection = await MySQLConnection.createConnection(
      host: endpoint.host,
      port: endpoint.port,
      userName: endpoint.userName,
      password: endpoint.password,
      collation: endpoint.collation,
      databaseName: endpoint.databaseName,
      secure: endpoint.secure,
    );

    return MySqlTransactionSQLDriver._(connection);
  }

  @override
  Future<bool> tableExists(String table, {String? schema}) async {
    var querySchema = schema;
    if (querySchema == null) {
      final result = await connection.execute('SELECT DATABASE();');
      final newChema = result.rows.first
          .typedColAt<String>(0); //rows.first.typedColAt<String>(0);
      if (newChema != null) querySchema = newChema;
    }

    final result = await connection.execute('''
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
  Future<AthenaQueryResponse> execute(
    String queryString, {
    Map<String, dynamic>? mapValues,
    bool? iterable,
  }) async {
    final mapper = QueryMapper(numered: false, prefixQuery: '?');

    final queryToExecute = mapper.getValues(queryString, mapValues ?? {});
    if (queryToExecute.args.isEmpty) {
      final result = await connection.execute(queryToExecute.query);
      final mapped = result.rows.map((e) => QueryRow(e.typedAssoc())).toList();
      return QueryResponse(mapped);
    }
    final prepared =
        await connection.prepare(queryToExecute.query, iterable ?? true);

    final result = await prepared.execute(queryToExecute.args);

    final mapped = result.rows.map((e) => QueryRow(e.typedAssoc())).toList();
    return QueryResponse(mapped);
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
  MySqlDriver._(MySQLConnection connection) : super._(connection);

  static Future<MySqlDriver> open(AthenaMySqlEndpoint endpoint) async {
    final connection = await MySQLConnection.createConnection(
      host: endpoint.host,
      port: endpoint.port,
      userName: endpoint.userName,
      password: endpoint.password,
      collation: endpoint.collation,
      databaseName: endpoint.databaseName,
      secure: endpoint.secure,
    );
    await connection.connect();

    return MySqlDriver._(connection);
  }

  @override
  Future<void> close() async {
    if (!_isOpen) return;
    await connection.close();
    _isOpen = false;
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) {
    return connection.transactional((conn) {
      return trx(MySqlTransactionSQLDriver._(conn));
    });
  }
}

class AthenaMySQL extends AthenaSQL<MySqlDriver> {
  AthenaMySQL._(MySqlDriver driver) : super(driver);

  static Future<AthenaMySQL> open(AthenaMySqlEndpoint endpoint) async {
    final driver = await MySqlDriver.open(endpoint);
    return AthenaMySQL._(driver);
  }

  static Future<AthenaMySQL> fromMapConnection(
      Map<String, dynamic> connection) async {
    final config = AthenaMySqlEndpoint.fromMap(connection);
    final athena = await AthenaMySQL.open(config);
    return athena;
  }
}
