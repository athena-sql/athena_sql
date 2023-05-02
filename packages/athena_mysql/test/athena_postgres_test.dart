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
          .column((t) => t.$customType('id', type: 'INT'))
          .run();
      expect(completed, equals(0));
      final result = await conn.tableExists('users');
      expect(result, equals(true));
    });
  });
}
