// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('Alter Table', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('alter.table', () {
      test('add column', () {
        final query = athenaSql.alter
            .table('product')
            .addColumn((q) => q.$customType('name', type: 'type'));
        final built = query.build();

        const expectedBuild = 'ALTER TABLE product ADD COLUMN name type';

        expect(built, expectedBuild);
      });

      test('multi add column', () {
        final query = athenaSql.alter
            .table('product')
            .addColumn((q) => q.$customType('name', type: 'type'))
            .addColumn((q) => q.$customType('name2', type: 'type2'));
        final built = query.build();

        const expectedBuild =
            'ALTER TABLE product ADD COLUMN name type, ADD COLUMN name2 type2';

        expect(built, expectedBuild);
      });

      test('drop column', () {
        final query = athenaSql.alter
            .table('product')
            .dropColumn('name')
            .dropColumn('name2');
        final built = query.build();

        const expectedBuild =
            'ALTER TABLE product DROP COLUMN name, DROP COLUMN name2';

        expect(built, expectedBuild);
      });
    });
  });
}
