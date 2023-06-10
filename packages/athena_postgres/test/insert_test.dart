import 'package:athena_postgres/athena_postgres.dart';
import 'package:test/test.dart';

import 'docker.dart';

void main() {
  usePostgresDocker();
  group('Columns', () {
    final athena = AthenaPostgresql(PostgresDatabaseConfig(
        'localhost', 5432, 'dart_test',
        username: 'dart', password: 'dart'));

    setUpAll(() async {
      await athena.open();

      await athena.create
          .table('users')
          .column((t) => t.serial('id').primaryKey())
          .column((t) => t.text('Name'))
          .column((t) => t.text('email'))
          .column((t) => t.int_('age'))
          .run();
      // Additional setup goes here.
    });
    setUp(() {
      return athena.rawQuery('''
      TRUNCATE TABLE users
      RESTART IDENTITY;
      ''');
    });
    tearDownAll(() async => await athena.close());

    test('execute query', () async {
      final inserted = await athena.insert.into('users').values({
        'Name': 'juan',
        'email': 'juan@example.com'
      }).values({'Name': 'pedro', 'email': 'pedro@example.com'}).values(
          {'Name': 'maria', 'email': 'maria@example.com', 'age': 3}).run();

      expect(inserted, equals(3));

      final selected = await athena
          .select(['Name', 'email'])
          .from('users')
          .as('u')
          .where((w) => w['u.Name'].noEq('@name'))
          .run(mapValues: {'name': 'juan'});
      // expect
      expect(
          selected,
          equals([
            {'Name': 'pedro', 'email': 'pedro@example.com'},
            {'Name': 'maria', 'email': 'maria@example.com'}
          ]));
    });

    test('return values', () async {
      final inserted = await athena.insert
          .into('users')
          .values({'Name': 'juan', 'email': 'juan@example.com'}).values(
              {'Name': 'pedro', 'email': 'pedro@example.com'}).values({
        'Name': 'maria',
        'email': 'maria@example.com',
        'age': 3
      }).returning(['id', 'Name']).run();

      expect(
          inserted,
          equals([
            {'id': 1, 'Name': 'juan'},
            {'id': 2, 'Name': 'pedro'},
            {'id': 3, 'Name': 'maria'}
          ]));
    });
  });
}
