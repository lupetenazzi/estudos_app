import '../entities/task.dart';
import '../repositories/i_task_repository.dart';

class UpdateTask {
  final ITaskRepository repository;
  UpdateTask(this.repository);

  Future<void> call(Task task) async {
    await repository.updateTask(task);
  }
}