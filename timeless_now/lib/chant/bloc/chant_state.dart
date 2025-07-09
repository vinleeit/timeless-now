part of 'chant_bloc.dart';

@immutable
sealed class ChantState extends Equatable {
  const ChantState({
    required this.chants,
    required this.currentChantIndex,
    required this.fontSize,
  });

  final List<Chant> chants;
  final int currentChantIndex;
  final double fontSize;

  Chant? get currentChant =>
      (chants.isEmpty) ? null : chants[currentChantIndex];

  @override
  List<Object?> get props => [
        chants,
        currentChantIndex,
        () => currentChant?.selectedContent.iso,
        fontSize,
      ];
}

final class ChantInitialState extends ChantState {
  const ChantInitialState({
    super.chants = const [],
    super.currentChantIndex = 0,
    super.fontSize = 16,
  });
}

final class ChantReadyState extends ChantState {
  const ChantReadyState({
    required super.chants,
    required super.currentChantIndex,
    required super.fontSize,
  });
}
