import 'package:objectbox/objectbox.dart';
import 'package:timeless_now/models/meditation_record.dart';

final class MeditationRecordRepository {
  MeditationRecordRepository({
    required Store store,
  }) {
    _store = store;
  }

  late final Store _store;

  Box<MeditationRecord> get box => _store.box<MeditationRecord>();
}
