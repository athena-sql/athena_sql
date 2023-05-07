// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('SelectTableBuilder', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('select', () {
      test('from', () {
        final query = athenaSql.select(['id', 'name']).from('users').where(
            (t) =>
                (t['age'] > t.variable('age')) &
                (t['name'].like(t.string('%juan%'))));

        const expectedBuild = '''
            SELECT id, name FROM users
            WHERE age > @age AND name LIKE '%juan%'
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
        // expect(built.build(), equals(normalizeSql(expectedBuild)));
      });
    });
  });
}
