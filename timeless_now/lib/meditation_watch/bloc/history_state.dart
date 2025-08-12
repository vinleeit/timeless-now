part of 'history_bloc.dart';

@immutable
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

final class HistoryInitialState extends HistoryState {
  const HistoryInitialState();
}

final class HistoryReadyState extends HistoryState {
  const HistoryReadyState({
    required this.meditationRecords,
  }) : super();

  final List<MeditationRecord> meditationRecords;

  @override
  List<Object?> get props => [meditationRecords];
}
