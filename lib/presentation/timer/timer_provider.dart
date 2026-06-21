import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:estudos_app/data/local/app_database.dart';
import 'package:estudos_app/data/repositories/focus_session_repository_impl.dart';
import 'package:estudos_app/domain/repositories/i_focus_session_repository.dart';
import '../tasks/tasks_provider.dart';

final focusSessionDaoProvider = Provider<FocusSessionDao>((ref) {
  return FocusSessionDao(ref.watch(databaseProvider));
});

final focusSessionRepositoryProvider = Provider<IFocusSessionRepository>((ref) {
  return FocusSessionRepositoryImpl(ref.watch(focusSessionDaoProvider));
});