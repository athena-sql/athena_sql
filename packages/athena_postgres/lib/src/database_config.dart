import 'dart:convert';
import 'dart:io';

import 'package:postgres/postgres.dart';

import '../athena_postgres.dart';

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

/// The mode to use for queries.
class AthenaSessionSettings {
  /// The mode to use for queries.
  const AthenaSessionSettings({
    this.connectTimeout,
    this.queryTimeout,
    this.queryMode,
    this.ignoreSuperfluousParameters,
  });

  /// The connection timeout.
  final Duration? connectTimeout;

  /// The query timeout.
  final Duration? queryTimeout;

  /// The Query Execution Mode
  ///
  /// The default value is [QueryMode.extended] which uses the Extended Query
  /// Protocol. In certain cases, the Extended protocol cannot be used
  /// (e.g. in replication mode or with proxies such as PGBouncer), hence the
  /// the Simple one would be the only viable option. Unless necessary, always
  /// prefer using [QueryMode.extended].
  final QueryMode? queryMode;

  /// When set, the default query map will not throw exception when superfluous
  /// parameters are found.
  final bool? ignoreSuperfluousParameters;
}

/// The SSL mode to use for a connection.
enum AthenaSslMode {
  /// No SSL is used, implies that password may be sent as plaintext.
  disable,

  /// Always use SSL (but ignore verification errors).
  ///
  /// If you're using this option to accept self-signed certificates, consider
  /// the security ramifications of accepting _every_ certificate: Despite using
  /// TLS, MitM attacks are possible by injecting another certificate.
  /// An alternative is using [verifyFull] with a [SecurityContext] passed to
  /// [ConnectionSettings.securityContext] that only accepts the known
  /// self-signed certificate.
  require,

  /// Always use SSL and verify certificates.
  verifyFull,
  ;

  /// Whether to ignore certificate issues.
  bool get ignoreCertificateIssues => this == AthenaSslMode.require;

  /// Whether to allow cleartext passwords.
  bool get allowCleartextPassword => this == AthenaSslMode.disable;
}

/// Connection settings for connecting to a PostgreSQL database.
class AthenaConnectionSettings extends AthenaSessionSettings {
  /// Connection settings for connecting to a PostgreSQL database.
  const AthenaConnectionSettings({
    this.applicationName,
    super.connectTimeout,
    this.encoding,
    super.ignoreSuperfluousParameters,
    this.onOpen,
    super.queryMode,
    super.queryTimeout,
    this.securityContext,
    this.sslMode,
    this.timeZone,
    this.typeRegistry,
  });

  /// The name of the application connecting to the database.
  final String? applicationName;

  /// The timezone to use for the connection.
  final String? timeZone;

  /// The encoding to use for the connection.
  final Encoding? encoding;

  /// The SSL mode to use for the connection.
  final AthenaSslMode? sslMode;

  /// The [SecurityContext] to use when opening a connection.
  ///
  /// This can be configured to only allow some certificates. When used,
  /// [ConnectionSettings.sslMode] should be set to [SslMode.verifyFull], as
  /// this package will allow other certificates or insecure connections
  /// otherwise.
  final SecurityContext? securityContext;

  /// When set, use the type registry with custom types, instead of the
  /// built-in ones provided by the package.
  final TypeRegistry? typeRegistry;

  /// This callback function will be called after opening the connection.
  final Future<void> Function(AthenaPostgresql connection)? onOpen;
}
