import "../entities/task.dart";
import "../repositories/i_task_repository.dart";

class GetTask {

  final ITaskRepository repository;

  GetTask(this.repository);

  Future<List<Task>> call() async {
    return await repository.getTasks();
  }
}
