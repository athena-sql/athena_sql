// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:athena_sql/athena_sql.dart';
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

        when(mockDriver.transaction(any)).thenAnswer((_) async {
          final String ans =
              await _.positionalArguments[0](TestDatabaseTransactionDriver());
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
    group('query', () {
      test('rawQuery', () async {
        // arrange
        final tableName = 'users';
        when(mockDriver.tableExists(tableName)).thenAnswer((_) =>Future.value(true));
        // act
        final response = await athenaSql.tableExists(tableName);
        // assert
        verify(mockDriver.tableExists(tableName)).called(1);
        expect(response, equals(true));
      });
      test('rawQuery', () async {
        // arrange
        final query = 'SELECT * FROM users';
        final queryReponse = QueryResponse([]);
        when(mockDriver.query(query)).thenAnswer((_) =>Future.value(queryReponse));
        // act
        final response = await athenaSql.rawQuery(query);
        // assert
        verify(mockDriver.query(query)).called(1);
        expect(response, equals(queryReponse));
      });
    });
  });
}
