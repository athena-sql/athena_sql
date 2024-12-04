import 'package:postgres/postgres.dart';

/// PostgreSQL Endpoint for connecting to a PostgreSQL database.
class AthenaPostgresqlEndpoint {
  /// PostgreSQL Endpoint for connecting to a PostgreSQL database.
  const AthenaPostgresqlEndpoint({
    required this.host,
    this.port = 5432,
    required this.databaseName,
    this.username,
    this.password,
  });

  /// Hostname of database this connection refers to.
  final String host;

  /// Port of database this connection refers to.
  final int port;

  /// Name of database this connection refers to.
  final String databaseName;

  /// Username for authenticating this connection.
  final String? username;

  /// Password for authenticating this connection.
  final String? password;
}

/// Connection settings for connecting to a PostgreSQL database.
class AthenaConnectionSettings extends ConnectionSettings {
  /// Connection settings for connecting to a PostgreSQL database.
  const AthenaConnectionSettings({
    super.applicationName,
    super.connectTimeout,
    super.encoding,
    super.ignoreSuperfluousParameters,
    super.onOpen,
    super.queryMode,
    super.queryTimeout,
    super.replicationMode,
    super.securityContext,
    super.sslMode,
    super.timeZone,
    super.transformer,
    super.typeRegistry,
  });
}
