class AthenaMySqlEndpoint {
  const AthenaMySqlEndpoint({
    required this.host,
    required this.port,
    required this.userName,
    required this.password,
    this.secure = true,
    this.databaseName,
    this.collation = 'utf8mb4_general_ci',
  });

  final dynamic host;
  final int port;
  final String userName;
  final String password;
  final bool secure;
  final String? databaseName;
  final String collation;

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
