// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('Select Join', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    test('on', () {
      final query = athenaSql
          .select(['id', 'name'])
          .from('users')
          .where((t) => (t['age'] > '@age') & (t['name'].like('%juan%')))
          .join(
            'roles',
            'users.id',
            'roles.user_id',
          )
          .leftJoin(
            'products',
            'users.id',
            'products.user_id',
          )
          .fullJoin(
            'books',
            'users.id',
            'books.user_id',
          )
          .crossJoin(
            'cars',
            'users.id',
            'cars.user_id',
          )
          .innerJoin(
            'houses',
            'users.id',
            'houses.user_id',
          );

      const expectedBuild = '''
            SELECT id, name FROM users
            JOIN roles ON users.id = roles.user_id
            LEFT JOIN products ON users.id = products.user_id
            FULL JOIN books ON users.id = books.user_id
            CROSS JOIN cars ON users.id = cars.user_id
            INNER JOIN houses ON users.id = houses.user_id
            WHERE age > @age AND name LIKE '%juan%'
        ''';

      expect(query.build(), equals(normalizeSql(expectedBuild)));
    });
    test('builer', () {
      final query = athenaSql
          .select(['id', 'name'])
          .from('users')
          .where((t) => (t['age'] > '@age') & (t['name'].like('%juan%')))
          .joinBuilder('roles',
              as: 'r',
              on: (q) =>
                  (q['id'].eq(q['r.user_id']) & q['name'].eq(q['r.name'])));

      const expectedBuild = '''
            SELECT id, name FROM users
            JOIN roles AS r ON id = r.user_id AND name = r.name
            WHERE age > @age AND name LIKE '%juan%'
        ''';

      expect(query.build(), equals(normalizeSql(expectedBuild)));
    });
  });
}
