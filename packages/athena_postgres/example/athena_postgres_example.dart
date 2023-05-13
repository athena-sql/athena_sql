import 'package:athena_postgres/athena_postgres.dart';

void main() async {
  final athena = AthenaPostgresql(PostgresDatabaseConfig('host', 1, 'db'));

  await athena.open();

  await athena.create
      .table('user')
      .column((t) => t.$customType('name', type: 'text'))
      .run();

  await athena.drop.table('user').run();
}
