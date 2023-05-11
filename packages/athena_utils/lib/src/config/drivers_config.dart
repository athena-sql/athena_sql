part of 'config.dart';

enum _AthenaOptionsDriver {
  mysql('mysql'),
  postgresql('postgresql');

  const _AthenaOptionsDriver(this.name);
  final String name;

  /// Get the driver config
  AthenaDriverConfig toDriverConfig() => AthenaDriverConfig._fromDriver(this);
}

/// The sql driver config for the athena.yaml file
class AthenaDriverConfig {
  AthenaDriverConfig._({
    required this.importPackage,
    required this.initClass,
  });

  factory AthenaDriverConfig._fromDriver(_AthenaOptionsDriver driver) {
    switch (driver) {
      case _AthenaOptionsDriver.mysql:
        return AthenaDriverConfig._(
          importPackage: 'athena_mysql',
          initClass: 'AthenaMySQL',
        );
      case _AthenaOptionsDriver.postgresql:
        return AthenaDriverConfig._(
          importPackage: 'athena_postgres',
          initClass: 'AthenaPostgres',
        );
    }
  }

  /// The package to import
  String importPackage;

  /// The class to initialize
  String initClass;

  /// Get the constructor for the driver
  String getConstructor() {
    return '$initClass.fromMapConnection(config.connection)';
  }
}
