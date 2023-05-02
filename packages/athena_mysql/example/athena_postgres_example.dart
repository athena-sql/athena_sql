import 'package:athena_mysql/athena_mysql.dart';
import 'package:athena_sql/athena_sql.dart';

void main() async {
  final athena = AthenaMySql(MySqlDatabaseConfig('host', 1,
      userName: '', password: '', maxConnections: 1, databaseName: 'db'));

  await athena.open();

  await athena.create
      .table('user')
      .column((t) => t.$customType('name', type: 'text'))
      .run();

  await athena.drop.table('user').run();
}
