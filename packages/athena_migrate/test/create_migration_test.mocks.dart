// Mocks generated by Mockito 5.4.0 from annotations
// in athena_migrate/test/create_migration_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:athena_utils/src/config/config.dart' as _i2;
import 'package:athena_utils/src/console.dart' as _i4;
import 'package:athena_utils/src/files_service.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AthenaConfig].
///
/// See the documentation for Mockito's code generation for more information.
class MockAthenaConfig extends _i1.Mock implements _i2.AthenaConfig {
  MockAthenaConfig() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AthenaOptionsDriver get driver => (super.noSuchMethod(
        Invocation.getter(#driver),
        returnValue: _i2.AthenaOptionsDriver.mysql,
      ) as _i2.AthenaOptionsDriver);
  @override
  Map<String, dynamic> get connection => (super.noSuchMethod(
        Invocation.getter(#connection),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  String get migrationsPath => (super.noSuchMethod(
        Invocation.getter(#migrationsPath),
        returnValue: '',
      ) as String);
}

/// A class which mocks [FileService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFileService extends _i1.Mock implements _i3.FileService {
  MockFileService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  dynamic writeOn(
    String? path,
    String? contents,
  ) =>
      super.noSuchMethod(Invocation.method(
        #writeOn,
        [
          path,
          contents,
        ],
      ));
  @override
  bool exists(String? path) => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [path],
        ),
        returnValue: false,
      ) as bool);
  @override
  String read(String? path) => (super.noSuchMethod(
        Invocation.method(
          #read,
          [path],
        ),
        returnValue: '',
      ) as String);
  @override
  void withMemory() => super.noSuchMethod(
        Invocation.method(
          #withMemory,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [IOService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIOService extends _i1.Mock implements _i4.IOService {
  MockIOService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Never exit(int? code) => (super.noSuchMethod(
        Invocation.method(
          #exit,
          [code],
        ),
        returnValue: null,
      ) as Never);
}

/// A class which mocks [ProcessService].
///
/// See the documentation for Mockito's code generation for more information.
class MockProcessService extends _i1.Mock implements _i4.ProcessService {
  MockProcessService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<int> run(
    String? executable, {
    List<String>? arguments = const [],
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #run,
          [executable],
          {#arguments: arguments},
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);
}

/// A class which mocks [ConsoleService].
///
/// See the documentation for Mockito's code generation for more information.
class MockConsoleService extends _i1.Mock implements _i4.ConsoleService {
  MockConsoleService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool confirm(
    String? question, {
    bool? defaultValue = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirm,
          [question],
          {#defaultValue: defaultValue},
        ),
        returnValue: false,
      ) as bool);
  @override
  String ask(
    String? question, {
    String? defaultValue,
    bool? required,
    dynamic validator,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #ask,
          [question],
          {
            #defaultValue: defaultValue,
            #required: required,
            #validator: validator,
          },
        ),
        returnValue: '',
      ) as String);
  @override
  T menu<T>({
    required String? prompt,
    required List<T>? options,
    required String Function(T)? format,
  }) =>
      throw UnsupportedError(
          r'"menu" cannot be used without a mockito fallback generator.');
  @override
  List<String> find(
    String? pattern, {
    List<_i4.Find>? types = const [_i4.Find.file],
    bool? recursive = true,
    String? workingDirectory = r'.',
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #find,
          [pattern],
          {
            #types: types,
            #recursive: recursive,
            #workingDirectory: workingDirectory,
          },
        ),
        returnValue: <String>[],
      ) as List<String>);
}
