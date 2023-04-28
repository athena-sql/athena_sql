// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
import 'package:athena_sql/query_printable.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'utils/driver.dart';


@GenerateMocks([TestDatabaseDriver])
import 'drivers_test.mocks.dart';

abstract class OnDataReadComplete {
    call();
}
class MockOnDataReadComplete extends Mock implements OnDataReadComplete {}


void main() {
  group('AthenaDatabaseConnectionDriver', () {
    final mockDriver = MockTestDatabaseDriver();
    final athenaSql = AthenaSQL(mockDriver);
    setUp(() {
      // Additional setup goes here.
    });

    group('connection driver', () {
      test('open connection', () async {
        await athenaSql.open();
        verify(mockDriver.open()).called(1);
      });

      test('transaction', () async {
        //Creates the mock object

        when(mockDriver.transaction(any)).thenAnswer( (_) async {
          final String ans  = await _.positionalArguments[0](TestDatabaseTransactionDriver());
          return ans;
        });

        final mockOnDataReadComplete = MockOnDataReadComplete();
        final result = await athenaSql.transaction((_) async {
          mockOnDataReadComplete();
          return 'test';
        });
        verify(mockOnDataReadComplete()).called(1);
        verify(mockDriver.transaction(any)).called(1);
        expect(result, equals('test'));
      });
    });

  });
}
