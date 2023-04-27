import 'package:athena_sql/athena_sql.dart';
import 'package:postgres/messages.dart';
import 'package:postgres/postgres.dart';

import 'database_config.dart';

class PostgreSQLDriver extends AthenaDatabaseDriver {
  final PostgreSQLConnection connection;
  bool _isOpen = false;

  PostgreSQLDriver(PostgresDatabaseConfig config)
      : connection = PostgreSQLConnection(
            config.host, config.port, config.databaseName,
            username: config.username,
            password: config.password,
            useSSL: config.useSSL);

  @override
  Future<int> execute(String query) => connection.execute(query);

  @override
  Future<void> open() async {
    if (_isOpen) return;
    // if(connection.isClosed) throw Exception('Connection is closed');
    await connection.open();
    _isOpen = true;
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
