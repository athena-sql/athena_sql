import 'dart:async';

import 'package:athena_sql/athena_sql.dart';
import 'package:postgres/postgres.dart' as pg;

import 'database_config.dart';

/// Query driver for Postgres
class PostgreTransactionSQLDriver<T extends pg.Session>
    extends AthenaDatabaseDriver {
  PostgreTransactionSQLDriver._(this.connection);

  /// The connection to the database
  T connection;

  @override
  Future<bool> tableExists(String table, {String schema = 'public'}) async {
    final result = await connection.execute(pg.Sql.named('''
      SELECT EXISTS (
          SELECT FROM 
              pg_tables
          WHERE 
              schemaname = @schema AND 
              tablename  = @table
          );
      '''), parameters: {'schema': schema, 'table': table});

    return result.first.first! as bool;
  }

  @override
  Future<AthenaQueryResponse> execute(
    String queryString, {
    Map<String, dynamic>? mapValues,
    bool ignoreRows = false,
    Duration? timeout,
    bool? useSimpleQueryProtocol,
  }) async {
    final response = await connection.execute(
      pg.Sql.named(queryString),
      parameters: mapValues,
      ignoreRows: ignoreRows,
      timeout: timeout,
    );
    final mapped = response.map((e) => QueryRow(e.toColumnMap()));
    return QueryResponse(mapped, affectedRows: response.affectedRows);
  }

  @override
  AthenaColumnsDriver get columns => PostgresColumnsDriver();

  @override
  String mapColumnOrTable(String column) {
    final vals = column.split('.');
    return [
      for (final val in vals)
        if (val.contains(RegExp('[A-Z]'))) '"$val"' else val
    ].join('.');
  }
}

/// Columns driver for Postgres
class PostgresColumnsDriver extends AthenaColumnsDriver {
  @override
  ColumnDef boolean() => const ColumnDef('BOOLEAN');

  @override
  ColumnDef integer() => const ColumnDef('INTEGER');

  @override
  ColumnDef string() => const ColumnDef('VARCHAR');
}

/// Driver for Postgres
class PostgreSQLDriver extends PostgreTransactionSQLDriver<pg.Connection>
    implements AthenaDatabaseConnectionDriver {
  PostgreSQLDriver._(super.connection) : super._();

  /// Opens a connection to the database
  static Future<PostgreSQLDriver> open(AthenaPostgresqlEndpoint endpoint,
      AthenaConnectionSettings settings) async {
    final connection = await pg.Connection.open(
        pg.Endpoint(
          host: endpoint.host,
          database: endpoint.databaseName,
          port: endpoint.port,
          username: endpoint.username,
          password: endpoint.password,
        ),
        settings: settings);
    return PostgreSQLDriver._(connection);
  }

  @override
  Future<void> close() async {
    if (!connection.isOpen) return;
    await connection.close();
  }

  @override
  Future<T> transaction<T>(
      Future<T> Function(AthenaDatabaseDriver driver) trx) async {
    final val = await connection.runTx((connection) {
      return trx(PostgreTransactionSQLDriver._(connection));
    });

    return val;
  }
}

/// Athena Postgres SQL
class AthenaPostgresql extends AthenaSQL<PostgreSQLDriver> {
  AthenaPostgresql._(pg.Connection config) : super(PostgreSQLDriver._(config));

  /// Opens a connection to the database
  static Future<AthenaPostgresql> open(AthenaPostgresqlEndpoint config) async {
    final driver = await PostgreSQLDriver.open(config);
    return AthenaPostgresql._(driver.connection);
  }

  static final _listenings = <String>{};

  /// Listens to a channel
  Stream<String> listen(String channel) {
    if (!_listenings.contains(channel)) {
      unawaited(rawQuery('listen $channel'));
      _listenings.add(channel);
    }
    return driver.connection.channels.all
        .where((event) => event.channel == channel)
        .map((event) => event.payload);
  }
}

/// map secure getters
extension MapSecure on Map<String, dynamic> {
  /// Gets a value from the map
  T? optionalValue<T>(String key) {
    if (!containsKey(key)) {
      return null;
    }
    final val = this[key];
    if (val is! T) {
      throw Exception("Key '$key' is not of type ${T.toString()}");
    }
    return this[key] as T;
  }

  /// Gets a value from the map
  T getValue<T>(String key) {
    if (!containsKey(key)) {
      throw Exception("Key '$key' not found");
    }
    final val = this[key];
    if (val is! T) {
      throw Exception("Key '$key' is not of type ${T.toString()}");
    }
    return this[key] as T;
  }
}
