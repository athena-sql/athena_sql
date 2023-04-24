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

To use AthenaSQL in your Dart project, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  athena_sql: ^0.1.0
```

Then, import the library in your Dart code:

```dart
import 'package:athena_sql/athena_sql.dart';
```

## Usage

AthenaSQL provides an intuitive and chainable API to build SQL queries for various purposes. Here are some examples to get you started:

### SELECT

```dart
final query = AthenaSQL.select()
  .from("users")
  .columns(["id", "name", "email"])
  .where((c) => c
    .eq("active", true)
    .and(c.gte("age", 18))
    .or(c.eq("role", "admin")))
  .build();
```

### INSERT

```dart
final query = AthenaSQL.insert()
  .into("users")
  .columns(["name", "email", "password"])
  .values(["John Doe", "john.doe@example.com", "hashed_password"])
  .returning("*")
  .build();
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
  .build();
```

### DELETE

```dart
final query = AthenaSQL.delete()
  .from("users")
  .where("id = 1")
  .build();
```

### CREATE TABLE

```dart
final query = AthenaSQL.createTable("users")
  .addColumn((column) => column
    .serial("id")
    .primaryKey())
  .addColumn((column) => column
    .varchar("name", 50)
    .notNull())
  // ... add the remaining columns and constraints ...
  .build();
```

## Documentation

For more information on using AthenaSQL, check out the [official documentation](https://github.com/yourusername/athena_sql/wiki).

## Contributing

We welcome contributions to AthenaSQL! If you're interested in contributing, please read our [contributing guide](CONTRIBUTING.md) and submit a pull request.

## License

AthenaSQL is released under the [MIT License](LICENSE).