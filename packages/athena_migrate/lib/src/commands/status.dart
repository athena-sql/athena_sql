import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:yaml/yaml.dart';

import '../executable.dart';

//1 create
//2 validate
//3

const yamlTemplate = '''
# Athena Migrate Configuration

version: 1

database:
  # The database connection string.
  # The connection string is database specific.
  # For more information see:
  #
driver: mysql
connection: 'mysql://user:password@localhost:3306/dbname'
migrations:
  # The path to the migrations directory.
  # The path is relative to the athena.yaml file.
  # If not specified then the default is 'migrations'
  path: migrations
  # The path to a custom migration template
  # stub: migrations/template.stub

# development:
#   driver: mysql
#   connection:
#     host: localhost
#     username: user
#     password: password
#     port: 3306
#     database: dbname
''';

class AthenaConfig {
  final String driver;
  final String connection;
  final String migrationsPath;
  final String? migrationsStub;
  final String? migrationProgram;

  AthenaConfig({
    required this.driver,
    required this.connection,
    required this.migrationsPath,
    this.migrationsStub,
    this.migrationProgram = 'migrate'
  });

  factory AthenaConfig.fromYaml(YamlMap yaml) {
    return AthenaConfig(
      driver: yaml['driver'],
      connection: yaml['connection'],
      migrationsPath: yaml['migrations']['path'] ?? 'migrations',
      migrationsStub: yaml['migrations']['stub'],
    );
  }
}

class ReadConfig {
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
    final configFile = _configFile.readAsStringSync();
    YamlMap? yamlContent = loadYamlContent();
    if(yamlContent == null) return null;
    return AthenaConfig.fromYaml(yamlContent);
  }
}
