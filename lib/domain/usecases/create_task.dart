import '../entities/task.dart';
import '../repositories/i_task_repository.dart';

class CreateTask {
  final ITaskRepository repository;

  CreateTask(this.repository);

  Future<void> call(Task task) async {
    await repository.createTask(task);
  }
}

