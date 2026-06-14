import '../repositories/i_task_repository.dart';

class CompleteTask {
  final ITaskRepository repository;

  CompleteTask(this.repository);

  Future<void> call(int id) async {
    await repository.completeTask(id);
  }
}