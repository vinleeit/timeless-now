part of 'stopwatch_bloc.dart';

@immutable
sealed class MeditationTimerEvent extends Equatable {
  const MeditationTimerEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeMeditationTimer extends MeditationTimerEvent {
  const InitializeMeditationTimer();
}

final class StartTimer extends MeditationTimerEvent {
  const StartTimer();
}

class _TimerTick extends MeditationTimerEvent {
  const _TimerTick({required this.elapsed});

  final int elapsed;
}

final class StopTimer extends MeditationTimerEvent {
  const StopTimer();
}

final class UpdateNote extends MeditationTimerEvent {
  const UpdateNote({required this.note});

  final String note;

  @override
  List<Object?> get props => [note];
}

final class SaveRecord extends MeditationTimerEvent {
  const SaveRecord();
}
