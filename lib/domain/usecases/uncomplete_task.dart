import '../repositories/i_task_repository.dart';

class UncompleteTask {
  final ITaskRepository repository;
  UncompleteTask(this.repository);

  Future<void> call(int id) async {
    await repository.uncompleteTask(id);
  }
}