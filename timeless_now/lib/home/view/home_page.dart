import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeless_now/chant/view/chant_page.dart';
import 'package:timeless_now/meditation_watch/view/meditation_watch_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider<PageController>.value(
        value: _pageController,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            MeditationWatchPage(),
            ChantPage(),
          ],
        ),
      ),
    );
  }
}
