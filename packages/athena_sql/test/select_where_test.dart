// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('Select Where', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('isIn', () {
      test('from', () {
        final query = athenaSql.select(['id', 'name']).from('users').where(
            (t) =>
                (t['age'].isIn([t.variable('value1'), t.variable('value2')])));

        const expectedBuild = '''
            SELECT id, name FROM users
            WHERE age IN (@value1, @value2)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
    });
  });
}
