import 'package:drift/drift.dart';
import 'package:estudos_app/data/local/app_database.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;

class TaskModel {
  static domain.Task fromData(TasksTableData data) {
    return domain.Task(
      id: data.id,
      title: data.title,
      description: data.description,
      createdAt: data.createdAt,
      dueDate: data.dueDate,
      isCompleted: data.isCompleted,
      priority: data.priority,
      axisId: data.axisId,
    );
  }

  static TasksTableCompanion toCompanion(domain.Task task) {
    return TasksTableCompanion.insert(
      title: task.title,
      description: Value(task.description),
      dueDate: Value(task.dueDate),
      priority: Value(task.priority),
      axisId: task.axisId,
    );
  }
}