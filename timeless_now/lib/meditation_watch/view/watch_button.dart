import 'package:flutter/material.dart';

class WatchButton extends StatelessWidget {
  const WatchButton({
    required this.text,
    required this.icon,
    this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          Theme.of(context).textTheme.titleSmall,
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
        ),
      ),
      icon: Icon(
        icon,
        size: 24,
      ),
      label: Text(text),
    );
  }
}
