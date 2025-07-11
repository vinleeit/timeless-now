import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.controller,
    super.key,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12,
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
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Text('Version 1.0.1'),
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
                  for (final (index, title)
                      in ['Meditation Watch', 'Chant'].indexed)
                    ElevatedButton(
                      onPressed: () {
                        controller.jumpToPage(index);
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(
                          (index == controller.page)
                              ? Theme.of(context).primaryColor
                              : null,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          (index == controller.page) ? Colors.white : null,
                        ),
                        overlayColor: WidgetStateProperty.all(
                          (index == controller.page)
                              ? Colors.white.withAlpha(20)
                              : null,
                        ),
                      ),
                      child: Text(title),
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
