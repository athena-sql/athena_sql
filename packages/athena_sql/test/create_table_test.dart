// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/query_printable.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('CreateTableBuilder', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('table', () {
      test('conditions', () {
        final built = athenaSql.create.table('users').temporary().ifNotExists();
        const expectedBuild = '''
            CREATE TEMPORARY TABLE IF NOT EXISTS users()
        ''';
        expect(built.build(), equals(normalizeSql(expectedBuild)));
      });

      test('constrains', () {
        final built = athenaSql.create.table('users');

        const expectedBuild = '''
            CREATE TABLE IF NOT EXISTS users()
            CONSTRAINT employees_email_check CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,4}\$')
        ''';
        expect(built.build(), equals(normalizeSql(expectedBuild)));
      }, skip: true);
    });

    group('columns', () {
      test('data types', () {
        final query = athenaSql.create
            .table('product')
            .column((t) => t.$customType('id', type: 'UUID'))
            .column((t) => t.$customType('name', type: 'TEXT'));

        const expectedBuild = '''
            CREATE TABLE product(id UUID,
            name TEXT)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
      test('contrains', () {
        final query = athenaSql.create
            .table('employees')
            .column((t) => t.$customType('id', type: 'SERIAL').primaryKey())
            .column((t) => t.$customType('first_name',
                type: 'VARCHAR', parameters: ['${50}']).notNull())
            .column((t) => t
                .$customType('email', type: 'VARCHAR', parameters: ['${255}'])
                .unique()
                .notNull())
            .column(
                (t) => t.$customType('age', type: 'INTEGER').check('age >= 18'))
            .column((t) => t
                .$customType('hire_date', type: 'DATE')
                .defaultTo('CURRENT_DATE'))
            .column((t) =>
                t.$customType('active', type: 'BOOLEAN').defaultTo('TRUE'))
            .column(
                (t) => t.$customType('department_id', type: 'INT').references(
                      'departments',
                      column: 'id',
                      on: (q) => q.onDelete().cascade(),
                    ))
            .column((t) => t.$customType('salary',
                type: 'NUMERIC',
                parameters: ['${10}', '${2}']).check('salary >= 0'));

        const expectedBuild = '''
            CREATE TABLE employees(id SERIAL PRIMARY KEY,
                first_name VARCHAR(50) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                age INTEGER CHECK (age >= 18),
                hire_date DATE DEFAULT CURRENT_DATE,
                active BOOLEAN DEFAULT TRUE,
                department_id INT REFERENCES departments(id) ON DELETE CASCADE,
                salary NUMERIC(10,2) CHECK (salary >= 0))
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
      test('pre contrains', () {
        final query = athenaSql.create.table('employees').column((t) => t
            .$customType('id', type: 'INT')
            .primaryKey()
            .$addingPreContrains(
                QueryString().keyword('COLLATE ').userInput('pg_catalog."C"'))
            .$addingPreContrains(
                QueryString().keyword('COMPRESSION ').userInput('pglz')));

        const expectedBuild = '''
            CREATE TABLE employees(id INT COLLATE pg_catalog."C" COMPRESSION pglz PRIMARY KEY)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
    });
  });
}
