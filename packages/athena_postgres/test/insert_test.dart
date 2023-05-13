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
          .column((t) => t.text('name'))
          .column((t) => t.text('email'))
          .column((t) => t.int_('age'))
          .run();
      expect(completed, equals(0));

      final inserted = await athena.insert
          .into('users')
          .values({'name': 'juan', 'email': 'juan@example.com'}).values({
        'name': 'pedro',
        'email': 'pedro@example.com'
      }).values({'name': 'maria', 'email': 'maria@example.com'}).run();

      expect(inserted, equals(3));

      final selected = await athena
          .select(['name', 'email'])
          .from('users')
          .where((w) => w['name'].noEq(w.variable('name')))
          .run(mapValues: {'name': 'juan'});
      // expect
      expect(
          selected,
          equals([
            {'name': 'pedro', 'email': 'pedro@example.com'},
            {'name': 'maria', 'email': 'maria@example.com'}
          ]));
    });
  });
}
