import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estudos_app/data/local/app_database.dart';
import 'package:estudos_app/data/repositories/task_repository_impl.dart';
import 'package:estudos_app/domain/entities/task.dart' as domain;
import 'package:estudos_app/domain/usecases/get_task.dart';
import 'package:estudos_app/domain/usecases/create_task.dart';
import 'package:estudos_app/domain/usecases/complete_task.dart';
import 'package:estudos_app/domain/usecases/delete_task.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final taskDaoProvider = Provider<TaskDao>((ref) {
  return TaskDao(ref.watch(databaseProvider));
});

final taskRepositoryProvider = Provider<TaskRepositoryImpl>((ref) {
  return TaskRepositoryImpl(ref.watch(taskDaoProvider));
});

final tasksProvider = FutureProvider<List<domain.Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return GetTask(repository)();
});

final createTaskProvider = Provider<CreateTask>((ref) {
  return CreateTask(ref.watch(taskRepositoryProvider));
});

final completeTaskProvider = Provider<CompleteTask>((ref) {
  return CompleteTask(ref.watch(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.watch(taskRepositoryProvider));
});