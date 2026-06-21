class FocusSessionEntity {
  final int id;
  final DateTime startedAt;
  final int durationMinutes;
  final bool isCompleted;
  final String mode;

  const FocusSessionEntity({
    required this.id,
    required this.startedAt,
    required this.durationMinutes,
    required this.isCompleted,
    required this.mode,
  });
}