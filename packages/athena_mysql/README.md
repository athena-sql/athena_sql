

# Athena MySQL

This package provides a MySQL database for Athena.

for documentation on how to use Athena, see the [Athena documentation](https://athena-sql.gitbook.io/)
or the [Athena repository](https://github.com/athena-sql/athena_sql)

## Usage
install the package
```bash
$ dart pub add athena_mysql
```

Create a database connection
```dart
import 'package:athena_mysql/athena_mysql.dart';

final athenaSql = AthenaMySQL(
    MySqlDatabaseConfig(
        'localhost', // required
        5432, // required
        username: 'user', // required
        password: 'password', // required
        maxConnections: 5, // required
        databaseName: 'database', // optional
        secure: true, // optional
        collation: 'utf8mb4_general_ci', // optional
        timeoutMs: 10000, // optional
    ),
);
```

to open a connection
```dart
await athenaSql.open();
```
