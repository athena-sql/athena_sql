/// Configuration for a MySQL database.
class AthenaMySqlEndpoint {
  /// Configuration for a MySQL database.
  const AthenaMySqlEndpoint({
    required this.host,
    required this.port,
    required this.userName,
    required this.password,
    this.secure = true,
    this.databaseName,
    this.collation = 'utf8mb4_general_ci',
  });

  /// Creates a new MySQL endpoint from a map.
  factory AthenaMySqlEndpoint.fromMap(Map<String, dynamic> map) {
    final host = map['host'] ?? 'localhost';
    final port = map['port'] ?? 3306;
    final user = map['user'] ?? 'root';
    final pass = map['password'] ?? '';
    return AthenaMySqlEndpoint(
      host: host,
      port: port,
      userName: user,
      password: pass,
      secure: map['secure'] as bool? ?? true,
      databaseName: map['database'] as String?,
      collation: map['collation'] as String? ?? 'utf8mb4_general_ci',
    );
  }

  /// Hostname of database this connection refers to.
  final dynamic host;

  /// Port of database this connection refers to.
  final int port;

  /// Username for authenticating this connection.
  final String userName;

  /// Password for authenticating this connection.
  final String password;

  /// Whether to use a secure connection.
  final bool secure;

  /// Name of database this connection refers to.
  final String? databaseName;

  /// Collation to use for the connection.
  final String collation;

  /// Creates a new MySQL endpoint with a different database.
  AthenaMySqlEndpoint copyWithDatabase(String? database) {
    return AthenaMySqlEndpoint(
      host: host,
      port: port,
      userName: userName,
      password: password,
      secure: secure,
      databaseName: database,
      collation: collation,
    );
  }
}
