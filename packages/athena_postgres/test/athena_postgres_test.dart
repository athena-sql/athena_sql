import 'package:athena_postgres/athena_postgres.dart';
import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'docker.dart';

void main() {
  usePostgresDocker();
  group('A group of tests', () {
    final athena = AthenaPostgresql(PostgresDatabaseConfig(
        'localhost', 5432, 'dart_test',
        username: 'dart', password: 'dart'));

    setUp(() async {
      await athena.open();
      // Additional setup goes here.
    });

    test('execute query', () async {
      final completed = await athena.create
          .table('users')
          .column((t) => t.int_('id').primaryKey())
          .column((t) => t.text('name'))
          .run();
      expect(completed, equals(0));
      final result = await athena.rawQuery('''
      SELECT EXISTS (
          SELECT FROM 
              pg_tables
          WHERE 
              schemaname = 'public' AND 
              tablename  = 'users'
          );
      ''');
      expect(result[0][0], equals(true));
    });
  });
}
