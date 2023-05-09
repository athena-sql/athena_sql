import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:yaml/yaml.dart';

import 'drivers_config.dart';

const yamlTemplate = '''
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

class AthenaConfig {
  final AthenaOptionsDriver driver;
  final Map<String,dynamic> connection;
  final String migrationsPath;
  final String? migrationsStub;
  final String? migrationProgram;

  AthenaConfig(
      {required this.driver,
      required this.connection,
      required this.migrationsPath,
      this.migrationsStub,
      this.migrationProgram = 'migrate'});

  factory AthenaConfig.fromYaml(YamlMap yaml) {
    AthenaOptionsDriver driver;
    try {
      driver = AthenaOptionsDriver.values.firstWhere((e) => e.name == yaml['driver']);
    } catch (e) {
      print(red('Invalid driver, posible drivers are: ${AthenaOptionsDriver.values.join(', ')}'));
      exit(1);
    }
    Map<String, dynamic> connection;
    try {
     connection = (yaml['connection'] as YamlMap).cast<String, dynamic>();
    } catch (e) {
      print(red('Invalid connection, please check the connection format'));
      exit(1);
    }
    return AthenaConfig(
      driver: driver,
      connection: connection,
      migrationsPath: yaml['migrations']['path'] ?? 'migrations',
      migrationsStub: yaml['migrations']['stub'],
    );
  }
}

class ReadAthenaConfig {
  static final _configFile = File('athena.yaml');
  File? createConfig() {
    final create = confirm('Would you like to create one?', defaultValue: true);
    if (!create) return null;

    print(yellow('Creating athena.yaml'));
    final file = _configFile
      ..createSync()
      ..writeAsStringSync(yamlTemplate);
    print(yellow('athena.yaml created'));
    return file;
  }

  YamlMap? loadYamlContent() {
    final configFile = _configFile.readAsStringSync();
    YamlMap? yamlContent;
    try {
      yamlContent = loadYaml(configFile);
      if (yamlContent == null) {
        print(red('athena.yaml is empty'));
        if (createConfig() == null) return null;
        loadYamlContent();
      }
      return yamlContent;
    } on YamlException catch (e) {
      print(red('athena.yaml is invalid'));
      print(red(e.message));
      exit(1);
    }
  }

  AthenaConfig? run() {
    if (!_configFile.existsSync()) {
      print(red('athena.yaml not found'));
      if (createConfig() == null) return null;
    }
    YamlMap? yamlContent = loadYamlContent();
    if (yamlContent == null) return null;
    return AthenaConfig.fromYaml(yamlContent);
  }
    AthenaConfig getConfig() {
    if (!_configFile.existsSync()) {
      print(red('athena.yaml not found'));
      if (createConfig() == null) throw Exception('athena.yaml is needed');
    }
    YamlMap? yamlContent = loadYamlContent();
    if (yamlContent == null) throw Exception('athena.yaml wrong format');
    return AthenaConfig.fromYaml(yamlContent);
  }
}
