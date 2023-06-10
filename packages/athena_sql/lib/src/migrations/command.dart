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
      Print.red('Please provide a command');
      return;
    }
    final command = args.first;
    Print.green('running command $command');
    switch (command) {
      case 'up':
        return _runUp();
      case 'down':
        return _runDown();
      case 'all':
        return _runnAll();
      case 'reset':
        return _runReset();
      case 'redo':
        return _runRedo();
      case 'refresh':
        return _runRefresh();
      case 'status':
        return _runStatus();
      case 'version':
        return _runVersion();
      default:
        Print.red('Command $command not found');
    }
  }

  Future<bool> _checkTable() async {
    return athenaSql.transaction((db) async {
      final exists = await db.tableExists('athena_migrations');
      if (!exists) {
        Print.green('creating migration table');
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

  Future<List<AthenaMigration>> _migrationsPending() async {
    if (migrations.isEmpty) {
      return <AthenaMigration>[];
    }
    final current = await _getCurrentMigration();
    final date = current?['date'] as String?;

    if (date == null) return migrations;
    return migrations
        .where((element) => element.date.compareTo(date) > 0)
        .sorted((a, b) => a.date.compareTo(b.date))
        .toList();
  }

  Future<List<AthenaMigration>> _migrationsDone() async {
    if (migrations.isEmpty) {
      return <AthenaMigration>[];
    }
    final current = await _getCurrentMigration();
    final date = current?['date'] as String?;

    if (date == null) return <AthenaMigration>[];
    return migrations
        .where((element) => element.date.compareTo(date) < 0)
        .sorted((a, b) => a.date.compareTo(b.date))
        .toList();
  }

  Future<void> _runUp() async {
    final migrationsPending = await _migrationsPending();
    if (migrationsPending.isEmpty) {
      Print.yellow('No migrations to run');
      return;
    }
    final migration = migrationsPending.firstOrNull;
    if (migration == null) {
      Print.red('No migrations to run');
      return;
    }
    Print.green('running migration ${migration.name}');
    await athenaSql.transaction((db) async {
      await migration.up(db);
      await db.insert.into('athena_migrations').values({
        'name': migration.name,
        'date': migration.date,
      }).run();
    });
    Print.blue('migration ${migration.name} finished');
    return;
  }

  Future<void> _runnAll() async {
    final pendingMigrations = await _migrationsPending();
    if (pendingMigrations.isEmpty) {
      Print.red('No migrations to run');
      return;
    }
    await athenaSql.transaction((db) async {
      for (var migration in pendingMigrations) {
        Print.green('running migration ${migration.name}');
        await migration.up(db);

        await db.insert.into('athena_migrations').values({
          'name': migration.name,
          'date': migration.date,
        }).run();
      }
    });
    Print.blue('migrations finished');
    return;
  }

  Future<void> _runDown() async {
    final migrationsDone = await _migrationsDone();
    if (migrationsDone.isEmpty) {
      Print.yellow('No migrations to rollback');
      return;
    }
    final migration = migrationsDone.lastOrNull;
    if (migration == null) {
      Print.red('No migrations to rollback');
      return;
    }
    Print.green('running migration ${migration.name}');
    await athenaSql.transaction((db) async {
      await migration.down(db);
      await db.rawQuery('''
        DELETE FROM athena_migrations
        WHERE name = '${migration.name}'
      ''');
    });
    Print.blue('migration down ${migration.name} finished');
  }

  Future<void> _runReset() async {
    final migrationsDone = await _migrationsDone();
    if (migrationsDone.isEmpty) {
      Print.yellow('No migrations to rollback');
      return;
    }
    await athenaSql.transaction((db) async {
      for (var migration in migrationsDone) {
        Print.green('running migration ${migration.name}');
        await migration.down(db);
        await db.rawQuery('''
          DELETE FROM athena_migrations
          WHERE name = '${migration.name}'
        ''');
      }
    });
    Print.blue('reset finished');
  }

  Future<void> _runRedo() async {
    final migrationsDone = await _migrationsDone();
    if (migrationsDone.isEmpty) {
      Print.yellow('No migrations to rollback');
      return;
    }
    final migration = migrationsDone.lastOrNull;
    if (migration == null) {
      Print.red('No migrations to rollback');
      return;
    }
    Print.green('running migration ${migration.name}');
    await athenaSql.transaction((db) async {
      await migration.down(db);
      await migration.up(db);
      await db.rawQuery('''
        UPDATE athena_migrations
        SET date = '${migration.date}'
        WHERE name = '${migration.name}'
      ''');
    });
    Print.blue('migration redoo ${migration.name} finished');
  }

  Future<void> _runStatus() async {
    final migrationsDone = await _migrationsDone();
    final migrationsPending = await _migrationsPending();
    if (migrationsDone.isEmpty && migrationsPending.isEmpty) {
      Print.yellow('No migrations to rollback');
      return;
    }
    Print.blue('Migrations done:');
    for (var migration in migrationsDone) {
      Print.green('  ${migration.name}');
    }
    Print.blue('Migrations pending:');
    for (var migration in migrationsPending) {
      Print.green('  ${migration.name}');
    }
  }

  Future<void> _runVersion() async {
    final current = await _getCurrentMigration();
    if (current == null) {
      Print.yellow('No migrations to rollback');
      return;
    }
    Print.blue('Current version: ${current['name']}');
  }

  Future<void> _runRefresh() async {
    await _runReset();
    await _runnAll();
  }
}
