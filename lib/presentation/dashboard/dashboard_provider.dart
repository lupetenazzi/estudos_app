import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_today_events.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:estudos_app/domain/entities/task.dart' as domain;
import '../../data/datasources/google_calendar_datasource.dart';
import '../tasks/tasks_provider.dart';

final googleCalendarDatasourceProvider = Provider<GoogleCalendarDatasource>((ref) {
  return GoogleCalendarDatasource();
});

final todayEventsProvider = FutureProvider<List<calendar.Event>>((ref) async {
  final datasource = ref.watch(googleCalendarDatasourceProvider);
  return GetTodayEvents(datasource)();
});

final todayTasksProvider = FutureProvider<List<domain.Task>>((ref) async {
  final tasks = await ref.watch(tasksProvider.future);
  final today = DateTime.now();
  return tasks.where((t) =>
    t.dueDate != null &&
    t.dueDate!.year == today.year &&
    t.dueDate!.month == today.month &&
    t.dueDate!.day == today.day
  ).toList();
});