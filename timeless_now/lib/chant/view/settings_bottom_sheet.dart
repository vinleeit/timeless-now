import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/chant/bloc/chant_bloc.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    double fontSizeMin = 12,
    double fontSizeMax = 24,
    super.key,
  })  : _fontSizeMin = fontSizeMin,
        _fontSizeMax = fontSizeMax,
        assert(fontSizeMin % 2 == 0, 'Font size min must be divisible by 2'),
        assert(fontSizeMax % 2 == 0, 'Font size max must be divisible by 2');

  final double _fontSizeMin;
  final double _fontSizeMax;

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet>
    with TickerProviderStateMixin {
  Future<void> importJson(BuildContext context) async {
    final value = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
      type: FileType.custom,
    );
    if (value == null || value.paths.isEmpty || !context.mounted) return;
    context.read<ChantBloc>().add(
          LoadChantFromJsonFile(
            filePath: value.paths.first!,
          ),
        );
    Navigator.pop(context);
  }

  void changeFontSize(
    BuildContext context,
    double newFontSize,
  ) {
    context.read<ChantBloc>().add(
          ChangeFontSize(
            fontSize: newFontSize,
          ),
        );
  }

  void increaseFontSize(
    BuildContext context,
    double currentFontSize,
  ) =>
      changeFontSize(context, currentFontSize + 2);

  void decreaseFontSize(
    BuildContext context,
    double currentFontSize,
  ) =>
      changeFontSize(context, currentFontSize - 2);

  @override
  Widget build(BuildContext context) {
    final sliderDivisions =
        ((widget._fontSizeMax - widget._fontSizeMin) / 2).toInt();
    return BottomSheet(
      onClosing: () {},
      animationController: BottomSheet.createAnimationController(this),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24).copyWith(top: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ElevatedButton(
                      onPressed: () => importJson(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined),
                          SizedBox(width: 4),
                          Text('Import'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.all(14).copyWith(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Font size',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          BlocBuilder<ChantBloc, ChantState>(
                            builder: (context, state) {
                              final fontSize = state.fontSize;
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: (fontSize == widget._fontSizeMin)
                                        ? null
                                        : () =>
                                            decreaseFontSize(context, fontSize),
                                    icon:
                                        const Icon(Icons.text_decrease_rounded),
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: fontSize,
                                      min: widget._fontSizeMin,
                                      max: widget._fontSizeMax,
                                      onChanged: (value) =>
                                          changeFontSize(context, value),
                                      label: fontSize.toInt().toString(),
                                      divisions: sliderDivisions,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (fontSize == widget._fontSizeMax)
                                        ? null
                                        : () =>
                                            increaseFontSize(context, fontSize),
                                    icon:
                                        const Icon(Icons.text_increase_rounded),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
