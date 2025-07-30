import 'package:objectbox/objectbox.dart';

@Entity()
final class ChantCache {
  ChantCache({
    this.chantJsonPath = '',
  });

  @Id()
  int id = 0;

  String chantJsonPath;
}

final class ChantCacheRepository {
  ChantCacheRepository({
    required Store store,
  }) {
    _store = store;
    _box = _store.box<ChantCache>();

    // Load app cache
    var data = _box.get(1);
    if (data == null) {
      data = ChantCache();
      _box.put(data);
    }
    _data = data;
  }

  late final Store _store;
  late final Box<ChantCache> _box;
  late final ChantCache _data;

  ChantCache get data {
    return _data;
  }

  void flush() {
    _box.put(_data, mode: PutMode.update);
  }
}
