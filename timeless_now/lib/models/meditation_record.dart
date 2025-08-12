import 'package:objectbox/objectbox.dart';

@Entity()
final class MeditationRecord {
  MeditationRecord({
    required this.meditationStartTime,
    required this.meditationDuration,
    this.meditationNote = '',
  });

  @Id()
  int id = 0;
  final DateTime meditationStartTime;
  final int meditationDuration;
  String meditationNote;
}
