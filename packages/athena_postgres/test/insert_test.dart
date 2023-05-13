import 'package:athena_postgres/athena_postgres.dart';
import 'package:test/test.dart';

import 'docker.dart';

void main() {
  usePostgresDocker();
  group('Columns', () {
    final athena = AthenaPostgresql(PostgresDatabaseConfig(
        'localhost', 5432, 'dart_test',
        username: 'dart', password: 'dart'));

    setUp(() async {
      print('open');
      await athena.open();
      print('opened');
      // Additional setup goes here.
    });
    tearDown(() async => await athena.close());

    test('execute query', () async {
      print('testing');
      final completed = await athena.create
          .table('users')
          .column((t) => t.text('Name'))
          .column((t) => t.text('email'))
          .column((t) => t.int_('age'))
          .run();
      expect(completed, equals(0));

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
          .where((w) => w['u.Name'].noEq(w.variable('name')))
          .run(mapValues: {'name': 'juan'});
      // expect
      expect(
          selected,
          equals([
            {'Name': 'pedro', 'email': 'pedro@example.com'},
            {'Name': 'maria', 'email': 'maria@example.com'}
          ]));
    });
  });
}
