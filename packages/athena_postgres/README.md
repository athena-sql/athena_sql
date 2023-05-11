

# Athena Postgres

This package provides a Postgres database for Athena.

for documentation on how to use Athena, see the [Athena documentation](https://athena-sql.gitbook.io/)
or the [Athena repository](https://github.com/athena-sql/athena_sql)

## Usage
install the package
```bash
$ dart pub add athena_postgres
```

Create a database connection
```dart
import 'package:athena_postgres/athena_postgres.dart';

final athenaSql = AthenaPostgresql(
    PostgresDatabaseConfig(
        'localhost',
        5432,
        'database',
        username: 'user', // optional
        password: 'password', // optional
        database: 'database', // optional
        timeoutInSeconds: 30, // optional
        queryTimeoutInSeconds: 30, // optional
        timeZone: 'UTC', // optional
        useSSL: false, // optional
        isUnixSocket: false, // optional
        allowClearTextPassword: false, // optional
        replicationMode: ReplicationMode.none, // optional
    ),
);
```

to open a connection
```dart
await athenaSql.open();
```
