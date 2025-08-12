import 'package:objectbox/objectbox.dart';

enum WatchStatus {
  initial,
  running,
  stopped,
}

@Entity()
final class WatchCache {
  WatchCache({
    this.cachedMeditationWatchStartTime,
    this.elapsed = -1,
    this.note = '',
  });

  @Id()
  int id = 0;

  DateTime? cachedMeditationWatchStartTime;
  int elapsed;
  String note;

  WatchStatus get status {
    if (cachedMeditationWatchStartTime == null) {
      return WatchStatus.initial;
    }

    if (elapsed < 0) {
      return WatchStatus.running;
    }
    return WatchStatus.stopped;
  }
}

final class WatchCacheRepository {
  WatchCacheRepository({
    required Store store,
  }) {
    _store = store;
    _box = _store.box<WatchCache>();

    // Load app cache
    var data = _box.get(1);
    if (data == null) {
      data = WatchCache();
      _box.put(data);
    }
    _data = data;
  }

  late final Store _store;
  late final Box<WatchCache> _box;
  late final WatchCache _data;

  WatchCache get data {
    return _data;
  }

  void flush() {
    _box.put(_data, mode: PutMode.update);
  }

  void clear() {
    _data
      ..cachedMeditationWatchStartTime = null
      ..elapsed = -1
      ..note = '';

    _box.put(_data, mode: PutMode.update);
  }
}
