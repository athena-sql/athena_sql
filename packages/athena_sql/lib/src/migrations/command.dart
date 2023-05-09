import 'package:collection/collection.dart';

import '../../athena_sql.dart';

class MigrationCommands {
  final List<AthenaMigration> migrations;
  final List<String> args;
  final AthenaSQL<AthenaDatabaseConnectionDriver> athenaSql;
  MigrationCommands(this.migrations, this.args, this.athenaSql);

  Future<void> run() async {
    if (args.isEmpty) {
      print('Please provide a command');
      return;
    }
    final command = args.first;
    switch (command) {
      case 'up':
        return _runUp();
      case 'migrate':
        return migrate();
      case 'rollback':
        return rollback();
      case 'refresh':
        return refresh();
      case 'status':
        return status();
      default:
        print('Command $command not found');
    }
  }

  Future<bool> _checkTable() {
    return athenaSql.transaction((athenasql) async {
      final exists = await athenaSql.tableExists('athena_migrations');
      print('objectExists $exists');
      if (!exists) {
        await athenaSql.create
            .table('athena_migrations')
            .column((t) => t.string('name').notNull())
            .column((t) => t.string('date').notNull())
            .run();
        print('created');
        return true;
      }
      return false;
    });
  }

  Future<AthenaRowResponse?> _getCurrentMigration() async {
    final newTable = await _checkTable();
    if (newTable) {
      return null;
    }
    final query = '''
      SELECT * FROM athena_migrations
      ORDER BY date DESC
      LIMIT 1
    ''';
    print(query);
    final response = await athenaSql.rawQuery(query);
    print(response);
    if (response.isEmpty) {
      return null;
    }
    final row = response.first;
    return row;
  }

  Future<void> _runUp() async {
    final current = await _getCurrentMigration();
    final date = current?['date'] as String?;

    AthenaMigration? migration;
    print(date);
    print(migrations);
    if (date != null) {
      migration = migrations
          .where((element) => element.date.compareTo(date) > 0)
          .sorted((a, b) => a.date.compareTo(b.date))
          .firstOrNull;
    } else {
      migration = migrations.firstOrNull;
    }
    if (migration == null) {
      print('No migrations to run');
      return;
    }
    print('running migration ${migration.name}');
    await athenaSql.transaction((db) async {
      await migration!.up(db);
      return db.rawQuery('''
        INSERT INTO athena_migrations (name, date) VALUES (@name, @date)
      ''', mapValues: {
        'name': migration.name,
        'date': migration.date,
      });
    });
    print('migration ${migration.name} finished');
    return;
  }

  Future<void> migrate() async {
    print('comming soon');
  }

  Future<void> rollback() async {
    print('comming soon');
  }

  Future<void> status() async {
    print('comming soon');
  }

  Future<void> refresh() async {
    await rollback();
    await migrate();
  }
}
