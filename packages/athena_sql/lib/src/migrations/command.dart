import 'package:athena_utils/athena_utils.dart';
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

  Future<bool> _checkTable() async {
    return athenaSql.transaction((db) async {
      final exists = await db.tableExists('athena_migrations');
      if (!exists) {
        print('creating migration table');
        await db.create
            .table('athena_migrations')
            .column((t) => t.string('name').notNull())
            .column((t) => t.string('date').notNull())
            .run();
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
    final response = await athenaSql.rawQuery(query);
    if (response.isEmpty) {
      return null;
    }
    final row = response.first;
    return row;
  }

  Future<void> _runUp() async {
    if (migrations.isEmpty) {
      Print.yellow('No migrations to run');
      return;
    }
    final current = await _getCurrentMigration();
    final date = current?['date'] as String?;

    AthenaMigration? migration;
    if (date != null) {
      migration = migrations
          .where((element) => element.date.compareTo(date) > 0)
          .sorted((a, b) => a.date.compareTo(b.date))
          .firstOrNull;
    } else {
      migration = migrations.firstOrNull;
    }
    if (migration == null) {
      Print.yellow('No migrations to run');
      return;
    }
    Print.yellow('running migration ${migration.name}');
    await athenaSql.transaction((db) async {
      await migration!.up(db);
      return db.rawQuery('''
        INSERT INTO athena_migrations (name, date) VALUES (@name, @date)
      ''', mapValues: {
        'name': migration.name,
        'date': migration.date,
      });
    });
    Print.blue('migration ${migration.name} finished');
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
