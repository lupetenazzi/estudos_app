import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_today_events.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:estudos_app/domain/entities/task.dart' as domain;
import '../../data/datasources/google_calendar_datasource.dart';
import '../../data/repositories/focus_session_repository_impl.dart';
import '../timer/timer_provider.dart';
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
  return tasks.where((t) => !t.isCompleted).toList();
});

final todayFocusMinutesProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(focusSessionRepositoryProvider);
  final sessions = await repository.getTodaysSessions();
  return sessions
      .where((s) => s.isCompleted)
      .fold<int>(0, (total, s) => total + s.durationMinutes);
});