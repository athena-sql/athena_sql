// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';

void main() {
  group('Drop Table', () {
    final athenaSql = AthenaSQL(TestDriver());
    setUp(() {
      // Additional setup goes here.
    });

    group('drop.table', () {
      test('simple drop', () {
        final query = athenaSql.drop.table('product');
        final built = query.build();

        const expectedBuild = 'DROP TABLE product';

        expect(built, expectedBuild);
      });
      test('complex drop', () {
        final built = athenaSql.drop
            .table('product')
            .table('user')
            .ifExists()
            .restrict()
            .cascade()
            .build();

        const expectedBuild = 'DROP TABLE IF EXISTS product,user CASCADE';

        expect(built, expectedBuild);
      });
    });
  });
}
