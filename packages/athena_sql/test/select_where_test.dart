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

    group('is in', () {
      test('IN', () {
        final query = athenaSql.select(['id', 'name']).from('users').where(
            (t) =>
                (t['age'].isIn(['@value1', '@value2'])));

        const expectedBuild = '''
            SELECT id, name FROM users
            WHERE age IN (@value1, @value2)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
    });

    group('not', () {
      test('NOT LIKE', () {
        final query = athenaSql.select(['id', 'name']).from('users').where(
            (t) =>
                (t['age'].not().like('@ages')));

        const expectedBuild = '''
            SELECT id, name FROM users
            WHERE age NOT LIKE @ages
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
    });


    group('Nullable', () {
      test('NULL', () {
        final query = athenaSql.select(['id', 'name']).from('users').where(
            (t) =>
                (t['age'].isNull() | t['age'].isNotNull())
        );

        const expectedBuild = '''
            SELECT id, name FROM users
            WHERE age IS NULL OR age IS NOT NULL
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
    });
  });
}
