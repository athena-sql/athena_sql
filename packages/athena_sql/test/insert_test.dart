// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('InsertIntoBuilder', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('insert values', () {
      test('insert one', () {
        final query = athenaSql.insert.into('user').values({
          'name': 'juan',
          'age': 20,
        });

        const expectedBuild = '''
            INSERT INTO user (name, age) VALUES (@name_0, @age_0)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
        expect(
            query.$mappedValues(),
            equals({
              'name_0': 'juan',
              'age_0': 20,
            }));
      });
      test('inserts values chaining', () {
        final query = athenaSql.insert.into('user').values({
          'name': 'juan',
          'age': 20,
        }).addValues({
          'name': 'pedro',
          'age': 30,
          'email': 'pedro@example.com'
        }).addValues(
            {'name': 'maria', 'age': 40, 'email': 'maria@example.com'});

        const expectedBuild = '''
            INSERT INTO user (name, age, email) VALUES (@name_0, @age_0, NULL), (@name_1, @age_1, @email_1),
            (@name_2, @age_2, @email_2)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
        expect(
            query.$mappedValues(),
            equals({
              'name_0': 'juan',
              'age_0': 20,
              'name_1': 'pedro',
              'age_1': 30,
              'email_1': 'pedro@example.com',
              'name_2': 'maria',
              'age_2': 40,
              'email_2': 'maria@example.com',
            }));
      });

      test('inserts many values chaining', () {
        final query = athenaSql.insert.into('user').manyValues([
          {
            'name': 'juan',
            'age': 20,
          },
          {'name': 'pedro', 'age': 30, 'email': 'pedro@example.com'}
        ]).addManyValues([
          {'name': 'maria', 'age': 40, 'email': 'maria@example.com'}
        ]);

        const expectedBuild = '''
            INSERT INTO user (name, age, email) VALUES (@name_0, @age_0, NULL), (@name_1, @age_1, @email_1),
            (@name_2, @age_2, @email_2)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
        expect(
            query.$mappedValues(),
            equals({
              'name_0': 'juan',
              'age_0': 20,
              'name_1': 'pedro',
              'age_1': 30,
              'email_1': 'pedro@example.com',
              'name_2': 'maria',
              'age_2': 40,
              'email_2': 'maria@example.com',
            }));
      });

      test('insert returning', () {
        final query = athenaSql.insert.into('user').values({
          'Name': 'juan',
          'Age': 20,
        }).returning(['id', 'Name']);

        const expectedBuild = '''
            INSERT INTO user (Name, Age) VALUES (@Name_0, @Age_0)
            RETURNING id, Name
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
        expect(
            query.$mappedValues(),
            equals({
              'Name_0': 'juan',
              'Age_0': 20,
            }));
      });
    });
  });
}
