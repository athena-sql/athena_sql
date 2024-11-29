import 'dart:async';

import 'package:athena_sql/athena_sql.dart';
import 'package:postgres/postgres.dart' as pg;

import 'database_config.dart';

class PostgreTransactionSQLDriver<T extends pg.Session>
    extends AthenaDatabaseDriver {
  T connection;
  PostgreTransactionSQLDriver._(this.connection);

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

    return result.first.first as bool;
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

class PostgreSQLDriver extends PostgreTransactionSQLDriver<pg.Connection>
    implements AthenaDatabaseConnectionDriver {
  PostgreSQLDriver._(pg.Connection connection) : super._(connection);

  static Future<PostgreSQLDriver> open(AthenaPostgresqlEndpoint config) async {
    final connection = await pg.Connection.open(
      pg.Endpoint(
        host: config.host,
        database: config.databaseName,
        port: config.port,
        username: config.username,
        password: config.password,
      ),
    );
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

class AthenaPostgresql extends AthenaSQL<PostgreSQLDriver> {
  AthenaPostgresql._(pg.Connection config) : super(PostgreSQLDriver._(config));

  static Future<AthenaPostgresql> open(AthenaPostgresqlEndpoint config) async {
    final driver = await PostgreSQLDriver.open(config);
    return AthenaPostgresql._(driver.connection);
  }

  static final _listenings = <String>{};
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
