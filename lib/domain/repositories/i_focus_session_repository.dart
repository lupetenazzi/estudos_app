import '../entities/focus_session.dart';

abstract interface class IFocusSessionRepository {
  Future<void> saveSession(FocusSessionEntity session);
  Future<List<FocusSessionEntity>> getTodaysSessions();
}