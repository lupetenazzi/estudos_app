import "../entities/task.dart";
import "../repositories/i_task_repository.dart";

class GetPendingTasks {

  final ITaskRepository repository;

  GetPendingTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getPendingTasks();
  }
}
