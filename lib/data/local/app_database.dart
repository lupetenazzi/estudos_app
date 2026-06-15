import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Axes extends Table {

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class TasksTable extends Table {

  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  IntColumn get priority => integer().withDefault(const Constant(0))();

  IntColumn get axisId => integer().references(Axes, #id)();
  
}

class FocusSession extends Table {

  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get startedAt => dateTime()();

  IntColumn get durationMinutes => integer()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  TextColumn get mode => text()();
}

@DriftAccessor(tables: [TasksTable, Axes, FocusSession])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<List<TasksTableData>> getAllTasks() => select(tasksTable).get();

  Future<List<TasksTableData>> getPendingTasks() =>
    (select(tasksTable)..where((t) => t.isCompleted.equals(false))).get();

  Future<int> insertTask(TasksTableCompanion task) => into(tasksTable).insert(task);

  Future<void> completeTask(int id) =>
    (update(tasksTable)..where((t) => t.id.equals(id)))
        .write(const TasksTableCompanion(isCompleted: Value(true)));

  Future<void> deleteTask(int id) =>
    (delete(tasksTable)..where((t) => t.id.equals(id))).go();

  Future<void> uncompleteTask(int id) =>
    (update(tasksTable)..where((t) => t.id.equals(id)))
      .write(const TasksTableCompanion(isCompleted: Value(false)));

  Future<void> updateTask(TasksTableCompanion task, int id) =>
    (update(tasksTable)..where((t) => t.id.equals(id))).write(task);

}

@DriftDatabase(tables: [Axes, TasksTable, FocusSession], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(focusSession);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'estudos_app_db');
}