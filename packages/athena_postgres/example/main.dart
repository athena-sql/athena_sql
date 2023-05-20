import 'package:athena_postgres/athena_postgres.dart';

void main(List<String> args) async {
  final athenaSql = AthenaPostgresql(PostgresDatabaseConfig('host', 1, 'db'));

  await athenaSql.open();

  await athenaSql.create
      .table('users')
      .column((t) => t.string('name'))
      .column((t) => t.string('email'))
      .column((t) => t.int_('age'))
      .run();
  await athenaSql.insert
      .into('users')
      .values({'name': 'juan', 'email': 'juan@example.com'}).run();

  final selected = await athenaSql
      .select(['name', 'email'])
      .from('users')
      .as('u')
      .where((w) => w['u.name'].noEq('@name'))
      .run(mapValues: {'name': 'juan'});
  print(selected);
}
