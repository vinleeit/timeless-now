import 'package:flutter/material.dart';

class UnimplementedFeatureAlertDialog extends StatelessWidget {
  const UnimplementedFeatureAlertDialog({super.key});

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const UnimplementedFeatureAlertDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feature is not ready'),
      content: const Text('Stay tuned for the update!'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
