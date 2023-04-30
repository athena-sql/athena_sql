import 'package:athena_sql/athena_sql.dart';
import 'package:postgres/messages.dart';
import 'package:postgres/postgres.dart';

import 'database_config.dart';

class PostgreTransactionSQLDriver<T extends PostgreSQLExecutionContext>
    extends AthenaDatabaseDriver {
  T connection;
  PostgreTransactionSQLDriver._(this.connection);
  @override
  Future<int> execute(String query) => connection.execute(query);

  @override
  Future<bool> tableExists(String table, {String schema = 'public'}) async {
    final result = await connection.query('''
      SELECT EXISTS (
          SELECT FROM 
              pg_tables
          WHERE 
              schemaname = @schema AND 
              tablename  = @table
          );
      ''', substitutionValues: {'schema': schema, 'table': table});
    return result[0][0];
  }
}

class PostgreSQLDriver extends PostgreTransactionSQLDriver<PostgreSQLConnection>
    implements AthenaDatabaseConnectionDriver {
  // @override
  // final PostgreSQLConnection connection;
  bool _isOpen = false;
  final PostgresDatabaseConfig _config;

  PostgreSQLDriver(this._config)
      : super._(PostgreSQLConnection(
            _config.host, _config.port, _config.databaseName,
            username: _config.username,
            password: _config.password,
            useSSL: _config.useSSL));

  @override
  Future<int> execute(String query) => connection.execute(query);

  @override
  Future<void> open() async {
    if (_isOpen) return;
    if (connection.isClosed) {
      connection = PostgreSQLConnection(
          _config.host, _config.port, _config.databaseName,
          username: _config.username,
          password: _config.password,
          useSSL: _config.useSSL);
    }
    await connection.open();
    _isOpen = true;
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) {
    return connection.transaction((connection) {
      return trx(PostgreTransactionSQLDriver._(connection));
    }) as Future<T>;
  }
}

class AthenaPostgresql extends AthenaSQL<PostgreSQLDriver> {
  AthenaPostgresql(PostgresDatabaseConfig config)
      : super(PostgreSQLDriver(config));

  Stream<String> listen(String channel) {
    return driver.connection.messages.where((event) {
      if (event is NotificationResponseMessage) {
        return event.channel == channel;
      }
      return false;
    }).map((event) => (event as NotificationResponseMessage).payload);
  }

  Future<PostgreSQLResult> rawQuery(
    String query, {
    Map<String, dynamic>? substitutionValues,
    bool? allowReuse,
    int? timeoutInSeconds,
    bool? useSimpleQueryProtocol,
  }) {
    return driver.connection.query(query,
        substitutionValues: substitutionValues,
        allowReuse: allowReuse,
        timeoutInSeconds: timeoutInSeconds,
        useSimpleQueryProtocol: useSimpleQueryProtocol);
  }
}
