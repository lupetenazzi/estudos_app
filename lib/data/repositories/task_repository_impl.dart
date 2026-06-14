import "package:estudos_app/data/local/app_database.dart";
import "../../data/models/task_model.dart";
import "../../domain/entities/task.dart";
import "../../domain/repositories/i_task_repository.dart";  

class TaskRepositoryImpl implements ITaskRepository {

  final TaskDao _taskDao;

  TaskRepositoryImpl(this._taskDao);

  @override
  Future<List<Task>> getTasks() async {
    final taskDataList = await _taskDao.getAllTasks();
    return taskDataList.map((data) => TaskModel.fromData(data)).toList();
  }

  @override
  Future<List<Task>> getPendingTasks() async {
    final taskDataList = await _taskDao.getPendingTasks();
    return taskDataList.map((data) => TaskModel.fromData(data)).toList();
  }

  @override
  Future<void> createTask(Task task) async {
    final companion = TaskModel.toCompanion(task);
    await _taskDao.insertTask(companion);
  }

  @override
  Future<void> completeTask(int id) async {
    await _taskDao.completeTask(id);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _taskDao.deleteTask(id);    
  }

}