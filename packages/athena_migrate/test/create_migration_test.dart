// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'package:args/args.dart';
import 'package:athena_migrate/src/commands/create_migration.dart';
import 'package:athena_utils/athena_utils.dart';
import 'package:clock/clock.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  AthenaConfig,
  FileService,
  IOService,
  ProcessService
], customMocks: [
  MockSpec<ConsoleService>(unsupportedMembers: {#menu}),
])
import 'create_migration_test.mocks.dart';

void main() {
  group('CreateMigrationCommand', () {
    final athenaConfig = MockAthenaConfig();
    final fs = MockFileService();
    final console = MockConsoleService();
    final mockClock = Clock.fixed(DateTime(2000, 01, 01));
    CreateMigrationCommand command = CreateMigrationCommand(athenaConfig,
        console: console, fs: fs, clock: mockClock);
    CreateMigrationCommand(athenaConfig);
    setUp(() {
      reset(athenaConfig);
      reset(fs);
      reset(console);
      // Additional setup goes here.
    });

    group('create file', () {
      test('must ask for name and create file', () async {
        when(console.ask(any,
                required: anyNamed('required'),
                validator: anyNamed('validator')))
            .thenReturn('migration name');
        when(athenaConfig.driver).thenReturn(AthenaOptionsDriver.mysql);
        when(athenaConfig.migrationsPath).thenReturn('expectedPath');
        when(fs.writeOn(any, any)).thenReturn(null);
        await command.run(null);
        verify(fs.writeOn(
                'expectedPath/2000_01_01_000000_migration_name.dart', any))
            .called(1);
      });

      test('passing the name must not ask for it and create a file', () async {
        when(athenaConfig.driver).thenReturn(AthenaOptionsDriver.mysql);
        when(athenaConfig.migrationsPath).thenReturn('expectedPathWithParams');
        when(fs.writeOn(any, any)).thenReturn(null);

        final parser = ArgParser();
        final results = parser.parse(['migration', 'args']);
        await command.run(results);

        verify(fs.writeOn(
                'expectedPathWithParams/2000_01_01_000000_migration_args.dart',
                any))
            .called(1);
        verifyNever(console.ask(any,
            required: anyNamed('required'), validator: anyNamed('validator')));
      });
    });
  });
}
