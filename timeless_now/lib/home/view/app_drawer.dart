import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeless_now/home/models/page_index_model.dart';

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
        child: Consumer<PageIndexModel>(
          builder: (context, value, _) {
            return Column(
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
                        const Text('Version 1.0.0+9'),
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
                            Provider.of<PageIndexModel>(context, listen: false)
                                .updateIndex(index);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              (index == value.index)
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              (index == value.index) ? Colors.white : null,
                            ),
                            overlayColor: WidgetStateProperty.all(
                              (index == value.index)
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
            );
          },
        ),
      ),
    );
  }
}
