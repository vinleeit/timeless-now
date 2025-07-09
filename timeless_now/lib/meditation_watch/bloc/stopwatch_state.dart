part of 'stopwatch_bloc.dart';

@immutable
sealed class MeditationTimerState extends Equatable {
  const MeditationTimerState({
    required this.startTime,
    required this.elapsed,
  });

  final DateTime? startTime;
  final int elapsed;

  @override
  List<Object?> get props => [startTime, elapsed];
}

final class MeditationTimerInitial extends MeditationTimerState {
  const MeditationTimerInitial() : super(startTime: null, elapsed: 0);
}

final class MeditationTimerRunning extends MeditationTimerState {
  const MeditationTimerRunning({
    required super.startTime,
    required super.elapsed,
  });
}

final class MeditationTimerStopped extends MeditationTimerState {
  const MeditationTimerStopped({
    required super.startTime,
    required super.elapsed,
    required this.note,
  });

  final String note;

  @override
  List<Object?> get props => [
        super.startTime,
        super.elapsed,
        note,
      ];
}

final class MeditationTimerRecordSaved extends MeditationTimerState {
  const MeditationTimerRecordSaved({
    required super.startTime,
    required super.elapsed,
    required this.note,
  });

  final String note;

  @override
  List<Object?> get props => [
        super.startTime,
        super.elapsed,
        note,
      ];
}
