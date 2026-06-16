enum TimerStatus { idle, running, paused, finished }
enum TimerMode { pomodoro, free }

class TimerState {
  final TimerStatus status;
  final TimerMode mode;
  final int remainingSeconds;
  final int totalSeconds;
  final int completedCycles;

  TimerState({
    required this.status,
    required this.mode,
    required this.remainingSeconds,
    required this.totalSeconds,
    this.completedCycles = 0,
  });

  TimerState copyWith({
    TimerStatus? status,
    TimerMode? mode,
    int? remainingSeconds,
    int? totalSeconds,
    int? completedCycles,
  }) {
    return TimerState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      completedCycles: completedCycles ?? this.completedCycles,
    );
  }
}