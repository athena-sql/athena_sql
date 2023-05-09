


enum AthenaOptionsDriver { 
  mysql('mysql'), postgresql('postgresql');

  const AthenaOptionsDriver(this.name);
  final String name;

  AthenaDriverConfig getConfig() => AthenaDriverConfig.fromDriver(this);
}

class AthenaDriverConfig {
  String importPackage;
  String initClass;
  AthenaDriverConfig({
    required this.importPackage,
    required this.initClass,
  });

  factory AthenaDriverConfig.fromDriver(AthenaOptionsDriver driver) {
    switch (driver) {
      case AthenaOptionsDriver.mysql:
        return AthenaDriverConfig(
          importPackage: 'athena_mysql',
          initClass: 'AthenaMySQL',
        );
      case AthenaOptionsDriver.postgresql:
        return AthenaDriverConfig(
          importPackage: 'athena_postgres',
          initClass: 'AthenaPostgres',
        );
    }
  }

  String getConstructor()  {
    return '$initClass.fromMapConnection(config.connection)';
  }
}
