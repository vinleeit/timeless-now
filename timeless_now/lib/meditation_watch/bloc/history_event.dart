part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class InitializeHistory extends HistoryEvent {}

class AddHistory extends HistoryEvent {
  const AddHistory({
    required this.meditationRecord,
  });

  final MeditationRecord meditationRecord;
}

class RemoveHistory extends HistoryEvent {
  const RemoveHistory({
    required this.id,
  });

  final int id;
}
