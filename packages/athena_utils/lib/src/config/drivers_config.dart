part of 'config.dart';

/// sql driver options
enum AthenaOptionsDriver {
  /// mysql driver
  mysql('mysql'),

  /// postgresql driver
  postgresql('postgresql');

  const AthenaOptionsDriver(this.name);

  /// The name of the driver
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

  factory AthenaDriverConfig._fromDriver(AthenaOptionsDriver driver) {
    switch (driver) {
      case AthenaOptionsDriver.mysql:
        return AthenaDriverConfig._(
          importPackage: 'athena_mysql',
          initClass: 'AthenaMySQL',
        );
      case AthenaOptionsDriver.postgresql:
        return AthenaDriverConfig._(
          importPackage: 'athena_postgres',
          initClass: 'AthenaPostgresql',
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
