import 'package:objectbox/objectbox.dart';

@Entity()
final class AppCache {
  AppCache({
    this.cachedMeditationWatchStartTime,
    this.chantJsonPath = '',
  });

  @Id()
  int id = 0;

  DateTime? cachedMeditationWatchStartTime;
  String chantJsonPath;
}
