import 'package:athena_mysql/athena_mysql.dart';
import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'connection.dart';

void main() {
  group('A group of tests', () {
    useConnection();

    // setUp(() async {
    //   // await athena.open();
    //   // Additional setup goes here.
    // });
    // tearDown(() async => await athena.close());

    test('execute query', () async {
      final completed = await conn.create
          .table('users')
          .column((t) => t.int_('id'))
          .run();
      expect(completed, equals(0));
      final result = await conn.tableExists('users');
      await conn.rawQuery('INSERT INTO users (id) VALUES (@id)', mapValues: {'id': 1});
      final users = await conn.rawQuery('SELECT * FROM users');
      expect(users, equals([{'id': 1}]));
      expect(result, equals(true));
    });
  });
}
