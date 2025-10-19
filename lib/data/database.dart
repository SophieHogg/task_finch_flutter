import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

part 'database.g.dart';

enum Priority {
  high, medium, low
}

class Tasks extends Table {
  TextColumn get id => text().unique()();
  IntColumn get rId => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get description => text().nullable()();
  BoolColumn get completed => boolean()();
  TextColumn get priority => textEnum<Priority>().withDefault(Constant('medium'))();
  TextColumn get parentId => text().references(Tasks, #id).nullable()();
  DateTimeColumn get createdOn => dateTime()();
  DateTimeColumn get completedOn => dateTime().nullable()();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {

  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) async {
  //       await m.createAll();
  //     },
  //       beforeOpen: (openingDetails) async {
  //       final m = Migrator(this);
  //       await m.deleteTable(tasks.actualTableName);
  //       await m.createTable(tasks);
  //
  //       }
  //   );
  // }
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'task_finch_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),

      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }

}