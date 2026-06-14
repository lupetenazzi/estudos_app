import '../repositories/i_task_repository.dart';

class DeleteTask {
  final ITaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(int id) async {
    await repository.deleteTask(id);
  }
}