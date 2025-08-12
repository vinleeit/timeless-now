part of 'chant_bloc.dart';

@immutable
sealed class ChantEvent extends Equatable {
  const ChantEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChant extends ChantEvent {}

class LoadChantFromJsonFile extends ChantEvent {
  const LoadChantFromJsonFile({
    required this.filePath,
  });

  final String filePath;
}

class ChangeChant extends ChantEvent {
  const ChangeChant({
    required this.index,
  });

  final int index;
}

class ChangeChantContent extends ChantEvent {
  const ChangeChantContent({
    required this.iso,
  });

  final String iso;
}

class ChangeFontSize extends ChantEvent {
  const ChangeFontSize({
    required this.fontSize,
  });

  final double fontSize;
}
