import 'package:athena_mysql/athena_mysql.dart';
import 'package:test/test.dart';

import 'connection.dart';

void main() {
  useConnection();
  group('Columns', () {
    test('execute query', () async {
      print('testing');
      final completed = await conn.create
          .table('products')
          .column((t) => t.bit('t_bit', 1))
          .column((t) => t.doublePrecision('t_double_precision'))
          .column((t) => t.int_('t_int'))
          .column((t) => t.smallint('t_smallint'))
          .run();
      expect(completed, equals(0));
    });
  });
}
