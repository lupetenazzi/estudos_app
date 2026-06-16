import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'timer_state.dart';
import '../../services/notification_service.dart';
import 'package:vibration/vibration.dart';

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    return TimerState(
      status: TimerStatus.idle,
      mode: TimerMode.pomodoro,
      remainingSeconds: 25 * 60,
      totalSeconds: 25 * 60,
    );
  }

Future<void> startTimer() async {
  if (state.status == TimerStatus.running) return;

  state = state.copyWith(status: TimerStatus.running);
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (state.remainingSeconds > 0) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    } else {
      timer.cancel();
      state = state.copyWith(
        status: TimerStatus.finished,
        completedCycles: state.completedCycles + 1,
      );
      _onTimerFinished();
    }
  });
}

void pauseTimer() {
    if (state.status != TimerStatus.running) return;

    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

void continueTimer() {
    if (state.status != TimerStatus.paused) return;

    state = state.copyWith(status: TimerStatus.running);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
        state = state.copyWith(
          status: TimerStatus.finished,
          completedCycles: state.completedCycles + 1,
        );
        _onTimerFinished(); 
      }
    });
}

void cancelTimer() {
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.idle, remainingSeconds: state.totalSeconds, completedCycles: 0);
  }

}

Future<void> _onTimerFinished() async {
  await NotificationService.showNotification(
    'Sessão concluída! 🎉',
    'Seu Pomodoro terminou. Hora de descansar!',
  );
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 800);
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});