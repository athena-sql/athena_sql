# AthenaSQL

A powerful and elegant Dart SQL query builder inspired by the wisdom and strategy of the ancient Greek goddess Athena. AthenaSQL brings the grandeur and might of ancient empires to the digital era, providing an expressive and user-friendly API to build and manage SQL queries in your Dart projects.

![AthenaSQL Logo](assets/athena_sql_logo.png)

## Features

- Chainable and readable API for constructing SQL queries
- Support for various SQL statements like SELECT, INSERT, UPDATE, DELETE, and CREATE TABLE
- Advanced query features such as joins, subqueries, aliases, aggregation functions, and more
- Table creation with columns, data types, and constraints (primary key, foreign key, unique, and check)
- Extensible architecture to support custom data types and additional features

## Installation

To use Posrgresql or MySql with AthenaSQL, install the following packages:

for posrgresql:
```bash
dart pub add athena_postgres
```

for mysql
```bash
dart pub add athena_mysql
```

they come with athena_sql as a dependency.

If you want the sql builder without any database specific features, you can install athena_sql directly:

```bash
dart pub add athena_sql
```

Then, import the library in your Dart code:

```dart
import 'package:athena_sql/athena_sql.dart';
```

## Usage

AthenaSQL provides an intuitive and chainable API to build SQL queries for various purposes. Here are some examples to get you started:

### SELECT

```dart
final query = await athenaSQL.select(["id", "name", "email"])
  .from("users")
  .where((c) => 
    (c["active"] == c.value(true))) &&
    ((c["age"] >= c.value(18)) ||
    (c["role"] == c.value("admin")))
  .run();
```

### INSERT

```dart
final insertedAmount = await athenaSQL.insert
  .into("users")
  .values({
    "name": "John Doe",
    "email": "john.doe@example.com"
  })
  .run();
```

### UPDATE

```dart
final query = AthenaSQL.update()
  .table("users")
  .set({
    "name": "Jane Doe",
    "email": "jane.doe@example.com",
  })
  .where("id = 1")
  .run();
```

### DELETE

```dart
final query = AthenaSQL.delete()
  .from("users")
  .where("id = 1")
  .run();
```

### CREATE TABLE

```dart
final query = AthenaSQL.createTable("users")
  .column((c) => c.serial("id").primaryKey())
  .column((c) => c.varchar("name", 50).notNull())
  .run();
```

## TODO
- [ ] update builder
- [ ] delete builder
- [ ] constrains for create table
- [ ] joins
- [ ] subqueries


## Documentation

For more information on using AthenaSQL, check out the [official documentation](https://athena-sql.gitbook.io/).

## Contributing

We welcome contributions to AthenaSQL! If you're interested in contributing, please read our [contributing guide](CONTRIBUTING.md) and submit a pull request.

## License

AthenaSQL is released under the [BSD 3-Clause License](LICENSE).