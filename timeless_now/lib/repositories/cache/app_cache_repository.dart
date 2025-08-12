import 'package:objectbox/objectbox.dart';

@Entity()
final class AppCache {
  AppCache({
    this.lastVisitedRouteName = '',
  });

  @Id()
  int id = 0;

  String lastVisitedRouteName;
}

final class AppCacheRepository {
  AppCacheRepository({
    required Store store,
  }) {
    _store = store;
    _box = _store.box<AppCache>();

    // Load app cache
    var data = _box.get(1);
    if (data == null) {
      data = AppCache();
      _box.put(data);
    }
    _data = data;
  }

  late final Store _store;
  late final Box<AppCache> _box;
  late final AppCache _data;

  AppCache get data {
    return _data;
  }

  void flush() {
    _box.put(_data, mode: PutMode.update);
  }
}
