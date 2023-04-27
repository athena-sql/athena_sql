// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
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
            CREATE TEMPORARY TABLE IF NOT EXISTS users()
            CONSTRAINT employees_email_check CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]{2,4}\$')
        ''';
        expect(built.build(), equals(normalizeSql(expectedBuild)));
      }, skip: true);
    });

    group('columns', () {
      test('data types', () {
        final query = athenaSql.create
            .table('product')
            .column((t) => t.uuid('id'))
            .column((t) => t.text('name'))
            .column((t) => t.bigint('amount'))
            .column((t) => t.time('created', 1))
            .column((t) => t.money('price'))
            .column((t) => t.timestamptz('createdAt'));

        const expectedBuild = '''
            CREATE TABLE product(id UUID,
            name TEXT,
            amount BIGINT,
            created TIME(1),
            price MONEY,
            "createdAt" TIMESTAMPTZ)
        ''';

        expect(query.build(), equals(normalizeSql(expectedBuild)));
      });
      test('contrains', () {
        final query = athenaSql.create
            .table('employees')
            .column((t) => t.serial('id').primaryKey())
            .column((t) => t.varchar('first_name', 50).notNull())
            .column((t) => t.varchar('email', 255).unique().notNull())
            .column((t) => t.integer('age').check('age >= 18'))
            .column((t) => t.date('hire_date').defaultTo('CURRENT_DATE'))
            .column((t) => t.boolean('active').defaultTo('TRUE'))
            .column((t) => t.int_('department_id').references(
                  'departments',
                  column: 'id',
                  on: (q) => q.onDelete().cascade(),
                ))
            .column((t) => t.numeric('salary', 10, 2).check('salary >= 0'));

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
    });
  });
}
