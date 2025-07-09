import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({
    required this.currentIso,
    required this.isos,
    super.key,
  });

  final String currentIso;
  final List<String> isos;

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      animationController: BottomSheet.createAnimationController(this),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current language:',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.currentIso,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Icon(
                            Icons.check_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: widget.isos.length,
                      padding:
                          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      itemBuilder: (context, index) {
                        final iso = widget.isos[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(iso),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context, iso);
                            },
                            dense: true,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
