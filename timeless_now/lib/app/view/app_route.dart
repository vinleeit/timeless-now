import 'package:flutter/cupertino.dart';
import 'package:timeless_now/chant/view/chant_page.dart';
import 'package:timeless_now/meditation_watch/view/meditation_watch_page.dart';

class AppRoute {
  AppRoute._();

  static Map<String, WidgetBuilder> routes = {
    MeditationWatchPage.routeName: (context) => const MeditationWatchPage(),
    ChantPage.routeName: (context) => const ChantPage(),
  };

  static String defaultRoute = MeditationWatchPage.routeName;
}
