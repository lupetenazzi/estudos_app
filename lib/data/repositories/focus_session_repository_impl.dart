import 'package:drift/drift.dart';
import 'package:estudos_app/data/local/app_database.dart';
import 'package:estudos_app/domain/entities/focus_session.dart';
import 'package:estudos_app/domain/repositories/i_focus_session_repository.dart';

class FocusSessionRepositoryImpl implements IFocusSessionRepository {
  final FocusSessionDao _dao;

  FocusSessionRepositoryImpl(this._dao);

  @override
  Future<void> saveSession(FocusSessionEntity session) async {
    await _dao.insertFocusSession(
      FocusSessionCompanion(
        startedAt: Value(session.startedAt),
        durationMinutes: Value(session.durationMinutes),
        isCompleted: Value(session.isCompleted),
        mode: Value(session.mode),
      ),
    );
  }

  @override
  Future<List<FocusSessionEntity>> getTodaysSessions() async {
    final data = await _dao.getTodaysSessions();
    return data.map((d) => FocusSessionEntity(
      id: d.id,
      startedAt: d.startedAt,
      durationMinutes: d.durationMinutes,
      isCompleted: d.isCompleted,
      mode: d.mode,
    )).toList();
  }
}