// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';


void main() {
  group('CreateTableBuilder', () {
    setUp(() {
      // Additional setup goes here.
    });

    group('columns', () {
      test('data types', () {
        final query = CreateTableBuilder('product')
            .column((t) => t.uuid('id'))
            .column((t) => t.text('name'))
            .column((t) => t.bigint('amount'))
            .column((t) => t.date('created'))
            .column((t) => t.money('price'))
            .column((t) => t.timestamptz('createdAt'));
        final built = query.build();

        const expectedBuild = 'CREATE TABLE product(' +
            'id UUID, ' +
            'name TEXT, ' +
            'amount BIGINT, ' +
            'created DATE, ' +
            'price MONEY, ' +
            '"createdAt" TIMESTAMPTZ)';

        expect(built, expectedBuild);
      });
      test('contrains', () {
        final built = CreateTableBuilder('users')
            .column((t) => t
                .uuid('id')
                .primaryKey()
                .notNull()
                .defaultTo('uuid_generate_v4()'))
            .column((t) => t.text('name').collate('utf8_general_ci'))
            .column((t) => t.text('email').unique())
            .column((t) => t.uuid('city_id').references('cities', column: 'id'))
            .column(
                (t) => t.timestamptz('updated_at').notNull().defaultTo('NOW()'))
            .build();

        const expectedBuild = 'CREATE TABLE users(' +
            'id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(), ' +
            'name TEXT COLLATE utf8_general_ci, ' +
            'email TEXT UNIQUE, ' +
            'city_id UUID REFERENCES cities (id), ' +
            'updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW())';

        expect(built, expectedBuild);
      });
    });

  });
}
