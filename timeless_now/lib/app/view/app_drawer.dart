import 'package:flutter/material.dart';
import 'package:timeless_now/chant/view/chant_page.dart';
import 'package:timeless_now/meditation_watch/view/meditation_watch_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .padding
              .top + 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: const EdgeInsets.only(right: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tiratana Upasana',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                    const Text('Version 1.0.1+1'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final map
                  in {
                    'Meditation Watch': MeditationWatchPage.routeName,
                    'Chant': ChantPage.routeName,
                  }.entries)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          map.value,
                        );
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // backgroundColor: WidgetStateProperty.all(
                        //   (index == controller.page)
                        //       ? Theme.of(context).primaryColor
                        //       : null,
                        // ),
                        // foregroundColor: WidgetStateProperty.all(
                        //   (index == controller.page) ? Colors.white : null,
                        // ),
                        // overlayColor: WidgetStateProperty.all(
                        //   (index == controller.page)
                        //       ? Colors.white.withAlpha(20)
                        //       : null,
                        // ),
                      ),
                      child: Text(map.key),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
