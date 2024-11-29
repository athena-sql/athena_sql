import 'package:athena_postgres/athena_postgres.dart';
import 'package:test/test.dart';

import 'docker.dart';

void main() {
  usePostgresDocker();
  group('Basic test', () {
    late AthenaPostgresql athena;

    setUp(() async {
      athena = await AthenaPostgresql.open(AthenaPostgresqlEndpoint(
        host: 'localhost',
        databaseName: 'dart_test',
        username: 'postgres',
        password: 'dart',
      ));
      // Additional setup goes here.
    });
    tearDown(() async => await athena.close());

    test('execute query', () async {
      final tableName = 'create_table_test';
      final completed = await athena.create
          .table(tableName)
          .column((t) => t.int_('id').primaryKey())
          .column((t) => t.text('name'))
          .run();
      expect(completed, equals(0));
      final exists = await athena.tableExists(tableName);
      expect(exists, equals(true));
    });
  });
}
