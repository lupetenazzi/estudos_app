import 'package:estudos_app/data/local/app_database.dart';
import 'package:estudos_app/domain/entities/task.dart';

class TaskModel {
  static Task fromData(TaskData data) {
    return Task(
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

  static TasksCompanion toCompanion(Task task) {
    return TasksCompanion.insert(
      title: task.title,
      description: Value(task.description),
      dueDate: Value(task.dueDate),
      priority: Value(task.priority),
      axisId: task.axisId,
    );
  }
}