import 'package:postgres/postgres.dart';

class PostgresDatabaseConfig {
  PostgresDatabaseConfig(
    this.host,
    this.port,
    this.databaseName, {
    this.username,
    this.password,
    this.timeoutInSeconds = 30,
    this.queryTimeoutInSeconds = 30,
    this.timeZone = 'UTC',
    this.useSSL = false,
    this.isUnixSocket = false,
    this.allowClearTextPassword = false,
    this.replicationMode = ReplicationMode.none,
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

  /// Whether or not this connection should connect securely.
  final bool useSSL;

  /// The amount of time this connection will wait during connecting before giving up.
  final int timeoutInSeconds;

  /// The default timeout for [PostgreSQLExecutionContext]'s execute and query methods.
  final int queryTimeoutInSeconds;

  /// The timezone of this connection for date operations that don't specify a timezone.
  final String timeZone;

  /// If true, connection is made via unix socket.
  final bool isUnixSocket;

  /// If true, allows password in clear text for authentication.
  final bool allowClearTextPassword;

  /// The replication mode for connecting in streaming replication mode.
  ///
  /// When the value is set to either [ReplicationMode.physical] or [ReplicationMode.logical],
  /// the query protocol will no longer work as the connection will be switched to a replication
  /// connection. In other words, using the default [query] or [mappedResultsQuery] will cause
  /// the database to throw an error and drop the connection.
  ///
  /// Use [query] `useSimpleQueryProtocol` set to `true` or [execute] for executing statements
  /// while in replication mode.
  ///
  /// For more info, see [Streaming Replication Protocol]
  ///
  /// [Streaming Replication Protocol]: https://www.postgresql.org/docs/current/protocol-replication.html
  final ReplicationMode replicationMode;
}
