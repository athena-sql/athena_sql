import 'package:athena_sql/athena_sql.dart';
import 'package:postgres/messages.dart';
import 'package:postgres/postgres.dart';

import 'database_config.dart';

class PostgreTransactionSQLDriver<T extends PostgreSQLExecutionContext>
    extends AthenaDatabaseDriver {
  T connection;
  PostgreTransactionSQLDriver._(this.connection);

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

  @override
  Future<AthenaQueryResponse> query(
    String queryString, {
    Map<String, dynamic>? mapValues,
    bool? allowReuse,
    int? timeoutInSeconds,
    bool? useSimpleQueryProtocol,
  }) async {
    final response = await connection.query(queryString,
        substitutionValues: mapValues,
        allowReuse: allowReuse,
        timeoutInSeconds: timeoutInSeconds,
        useSimpleQueryProtocol: useSimpleQueryProtocol);
    final mapped = response.map((e) => QueryRow(e.toColumnMap()));
    return QueryResponse(mapped, affectedRows: response.affectedRowCount);
  }

  @override
  Future<int> execute(
    String queryString, {
    Map<String, dynamic>? mapValues,
    int? timeoutInSeconds,
  }) {
    return connection.execute(queryString,
        substitutionValues: mapValues, timeoutInSeconds: timeoutInSeconds);
  }

  @override
  AthenaColumnsDriver get columns => PostgresColumnsDriver();

  @override
  String mapColumnOrTable(String column) {
    final vals = column.split(".");
    return [
      for (final val in vals)
        if (val.contains(RegExp(r'[A-Z]'))) '"$val"' else val
    ].join(".");
  }
}

class PostgresColumnsDriver extends AthenaColumnsDriver {
  @override
  ColumnDef boolean() => ColumnDef('BOOLEAN');

  @override
  ColumnDef integer() => ColumnDef('INTEGER');

  @override
  ColumnDef string() => ColumnDef('VARCHAR');
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
  Future<void> close() async {
    if (!_isOpen) return;
    await connection.close();
    _isOpen = false;
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) async {
    final val = await connection.transaction((connection) {
      return trx(PostgreTransactionSQLDriver._(connection));
    });

    return val as T;
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

  static Future<AthenaPostgresql> fromMapConnection(
      Map<String, dynamic> config) async {
    final athena = AthenaPostgresql(PostgresDatabaseConfig(
      config.getValue('host'),
      config.getValue('port'),
      config.getValue('database'),
      username: config.optionalValue('username'),
      password: config.optionalValue('password'),
      useSSL: config.optionalValue('useSSL') ?? false,
      allowClearTextPassword:
          config.optionalValue('allowClearTextPassword') ?? false,
      timeZone: config.optionalValue('timeZone') ?? 'UTC',
      timeoutInSeconds: config.optionalValue('timeoutInSeconds') ?? 30,
      isUnixSocket: config.optionalValue('isUnixSocket') ?? false,
      queryTimeoutInSeconds:
          config.optionalValue('queryTimeoutInSeconds') ?? 30,
      replicationMode:
          config.optionalValue('replicationMode') ?? ReplicationMode.none,
    ));
    await athena.open();
    return athena;
  }
}

extension MapSecure on Map<String, dynamic> {
  T? optionalValue<T>(String key) {
    if (!containsKey(key)) {
      return null;
    }
    final val = this[key];
    if (val is! T) {
      throw Exception('Key \'$key\' is not of type ${T.toString()}');
    }
    return this[key] as T;
  }

  T getValue<T>(String key) {
    if (!containsKey(key)) {
      throw Exception('Key \'$key\' not found');
    }
    final val = this[key];
    if (val is! T) {
      throw Exception('Key \'$key\' is not of type ${T.toString()}');
    }
    return this[key] as T;
  }
}
