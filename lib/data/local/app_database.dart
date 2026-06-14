import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Axes extends Table {

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
}

class Tasks extends Table {

  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get dueDate => dateTime().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  IntColumn get priority => integer().withDefault(const Constant(0))();

  IntColumn get axisId => integer().references(Axes, #id)();
  
}

@DriftAccessor(tables: [Tasks, Axes])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Future<List<TaskData>> getAllTasks() => select(tasks).get();

  Future<List<TaskData>> getPendingTasks() =>
      (select(tasks)..where((t) => t.isCompleted.equals(false))).get();

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);

  Future<void> completeTask(int id) =>
      (update(tasks)..where((t) => t.id.equals(id)))
          .write(const TasksCompanion(isCompleted: Value(true)));

  Future<void> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();
}

@DriftDatabase(tables: [Axes, Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'estudos_app_db');
}