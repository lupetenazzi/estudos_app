import "package:estudos_app/data/local/app_database.dart";
import 'package:flutter/foundation.dart';
import "../../data/models/task_model.dart";
import 'package:estudos_app/domain/entities/task.dart' as domain;
import "../../data/datasources/supabase_task_datasource.dart";
import "../../domain/repositories/i_task_repository.dart";  

class TaskRepositoryImpl implements ITaskRepository {

  final TaskDao _taskDao;
  final SupabaseTaskDatasource _remoteDatasource;

  TaskRepositoryImpl(this._taskDao, this._remoteDatasource);

  @override
  Future<void> createTask(domain.Task task) async {
    await _taskDao.insertTask(TaskModel.toCompanion(task));
    try {
      await _remoteDatasource.insertTask(task);
    } catch (e, stack) {
      debugPrint('Supabase error: $e');
      debugPrint('Stack: $stack');
      rethrow;

    }
  }

  @override
  Future<void> completeTask(int id) async {
    await _taskDao.completeTask(id);
    try {
      await _remoteDatasource.completeTask(id);
    } catch (e, stack) {
      debugPrint('Supabase error: $e');
      debugPrint('Stack: $stack');
    }
  }

  @override
  Future<void> uncompleteTask(int id) async {
    await _taskDao.uncompleteTask(id);
    try {
      await _remoteDatasource.uncompleteTask(id);
    } catch (e, stack) {
      debugPrint('Supabase error: $e');
      debugPrint('Stack: $stack');
    }
  }

  @override
  Future<void> updateTask(domain.Task task) async {
    await _taskDao.updateTask(TaskModel.toCompanion(task), task.id);
    try {
      await _remoteDatasource.updateTask(task);
    } catch (e, stack) {
      debugPrint('Supabase error: $e');
      debugPrint('Stack: $stack');
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    await _taskDao.deleteTask(id);
    try {
      await _remoteDatasource.deleteTask(id);
    } catch (e, stack) {
      debugPrint('Supabase error: $e');
      debugPrint('Stack: $stack');
    }
  }


  @override
  Future<List<domain.Task>> getTasks() async {
    final taskDataList = await _taskDao.getAllTasks();
    return taskDataList.map((data) => TaskModel.fromData(data)).toList();
  }

  @override
  Future<List<domain.Task>> getPendingTasks() async {
    final taskDataList = await _taskDao.getPendingTasks();
    return taskDataList.map((data) => TaskModel.fromData(data)).toList();
  }

}