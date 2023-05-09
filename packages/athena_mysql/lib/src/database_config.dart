import 'package:mysql_client/mysql_client.dart';

class MySqlDatabaseConfig {
  MySqlDatabaseConfig(
    this.host,
    this.port, {
    required this.userName,
    required String password,
    required this.maxConnections,
    this.databaseName,
    this.secure = true,
    this.collation = 'utf8mb4_general_ci',
    this.timeoutMs = 10000,
  }) : _password = password;
  final String host;
  final int port;
  final String userName;
  final String _password;
  final int maxConnections;
  final String? databaseName;
  final bool secure;
  final String collation;
  final int timeoutMs;

  factory MySqlDatabaseConfig.fromMap(Map<String, dynamic> map) {
    final host = map['host'] ?? 'localhost';
    final port = map['port'] ?? 3306;
    final user = map['user'] ?? 'root';
    final pass = map['password'] ?? '';
    final maxConnections = map['maxConnections'] ?? 5;
    return MySqlDatabaseConfig(
      host,
      port,
      userName: user,
      password: pass,
      maxConnections: maxConnections,
      databaseName: map['database'] as String?,
      secure: map['secure'] as bool? ?? true,
      collation: map['collation'] as String? ?? 'utf8mb4_general_ci',
      timeoutMs: map['timeoutMs'] as int? ?? 10000,
    );
  }

  Future<MySQLConnection> getConnection() {
    return MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: userName,
      password: _password,
      databaseName: databaseName,
      secure: secure,
      collation: collation,
    );
  }

  MySqlDatabaseConfig copyWithDatabase(String? databaseName) {
    return MySqlDatabaseConfig(
      host,
      port,
      userName: userName,
      password: _password,
      maxConnections: maxConnections,
      databaseName: databaseName,
      secure: secure,
      collation: collation,
      timeoutMs: timeoutMs,
    );
  }
}
