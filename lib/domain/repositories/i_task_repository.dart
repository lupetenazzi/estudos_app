import '../entities/task.dart';

abstract interface class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<List<Task>> getPendingTasks();
  Future<void> createTask(Task task);
  Future<void> completeTask(int id);
  Future<void> deleteTask(int id);
}