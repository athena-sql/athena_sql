import 'dart:io';

import 'package:yaml/yaml.dart';

import '../console.dart';

part 'drivers_config.dart';

const _yamlTemplate = '''
# Athena Migrate Configuration

version: 1

database:
  # The database connection string.
  # The connection string is database specific.
  # For more information see:
  #
driver: postgresql
connection:
  host: localhost
  username: user
  password: password
  port: 3306
  database: dbname
migrations:
  # The path to the migrations directory.
  # The path is relative to the athena.yaml file.
  # If not specified then the default is 'migrations'
  path: migrations
  # The path to a custom migration template
  # stub: migrations/template.stub
''';

/// Create and manage the athena.yaml file
class AthenaConfig {
  AthenaConfig._(
      {required this.driver,
      required this.connection,
      required this.migrationsPath});

  factory AthenaConfig._fromYaml(YamlMap yaml) {
    AthenaOptionsDriver driver;
    try {
      driver = AthenaOptionsDriver.values
          .firstWhere((e) => e.name == yaml['driver']);
    } catch (e) {
      final drivers = AthenaOptionsDriver.values.map((e) => e.name).join(', ');
      Print.red('Invalid driver, posible drivers are: $drivers');
      exit(1);
    }
    Map<String, dynamic> connection;
    try {
      connection = (yaml['connection'] as YamlMap).cast<String, dynamic>();
    } catch (e) {
      Print.red('Invalid connection, please check the connection format');
      exit(1);
    }
    return AthenaConfig._(
      driver: driver,
      connection: connection,
      migrationsPath: yaml['migrations']['path'] ?? 'migrations',
    );
  }

  /// selected sql driver
  final AthenaOptionsDriver driver;

  /// connection information for a driver
  final Map<String, dynamic> connection;

  /// path to migrations directory
  final String migrationsPath;
}

/// Read the athena.yaml file
class ReadAthenaConfig {
  /// Create a new instance of ReadAthenaConfig
  ReadAthenaConfig({ConsoleService? console})
      : _console = console ?? ConsoleService.instance;
  final ConsoleService _console;
  static final _configFile = File('athena.yaml');
  File? _createConfig() {
    final create =
        _console.confirm('Would you like to create one?', defaultValue: true);
    if (!create) return null;
    final file = _configFile
      ..createSync()
      ..writeAsStringSync(_yamlTemplate);
    Print.blue('athena.yaml created');
    return file;
  }

  YamlMap? _loadYamlContent() {
    final configFile = _configFile.readAsStringSync();
    YamlMap? yamlContent;
    try {
      yamlContent = loadYaml(configFile);
      if (yamlContent == null) {
        Print.red('athena.yaml is empty');
        if (_createConfig() == null) return null;
        return _loadYamlContent();
      }
      return yamlContent;
    } on YamlException catch (e) {
      Print.red('athena.yaml is invalid');
      Print.red(e.message);
      exit(1);
    }
  }

  /// Check if the athena.yaml file exists
  AthenaConfig? run() {
    if (!_configFile.existsSync()) {
      Print.red('athena.yaml not found');
      if (_createConfig() == null) return null;
    }
    final yamlContent = _loadYamlContent();
    if (yamlContent == null) return null;
    return AthenaConfig._fromYaml(yamlContent);
  }

  /// Get the athena.yaml file
  AthenaConfig getConfig() {
    if (!_configFile.existsSync()) {
      Print.red('athena.yaml not found');
      if (_createConfig() == null) throw Exception('athena.yaml is needed');
    }
    final yamlContent = _loadYamlContent();
    if (yamlContent == null) throw Exception('athena.yaml wrong format');
    return AthenaConfig._fromYaml(yamlContent);
  }
}
