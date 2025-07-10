import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeless_now/chant/view/chant_page.dart';
import 'package:timeless_now/home/models/page_index_model.dart';
import 'package:timeless_now/home/view/app_drawer.dart';
import 'package:timeless_now/meditation_watch/view/meditation_watch_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final pageController = PageController(initialPage: 1);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PageIndexModel>(
      create: (context) => PageIndexModel(index: pageController.initialPage),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Consumer<PageIndexModel>(
            builder: (context, value, _) {
              final titleStr = switch (value.index) {
                1 => 'Chant',
                _ => 'Meditation Watch',
              };
              return Text(titleStr);
            },
          ),
        ),
        drawer: AppDrawer(
          controller: pageController,
        ),
        body: PageView(
          controller: pageController,
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
