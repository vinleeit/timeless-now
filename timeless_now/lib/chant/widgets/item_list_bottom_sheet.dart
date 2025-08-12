import 'package:flutter/material.dart';

class ItemListBottomSheet<T> extends StatefulWidget {
  const ItemListBottomSheet({
    required this.selectedItem,
    required this.items,
    required this.descriptionBuilder,
    required this.contentBuilder,
    this.description = 'item',
    super.key,
  });

  final T selectedItem;
  final List<T> items;
  final (bool, String) Function(T currentItem, T selectedItem) contentBuilder;
  final String Function(T selectedItem) descriptionBuilder;
  final String description;

  @override
  State<ItemListBottomSheet<T>> createState() => _ItemListBottomSheetState<T>();
}

class _ItemListBottomSheetState<T> extends State<ItemListBottomSheet<T>>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.selectedItem;
    final items = widget.items;
    final contentBuilder = widget.contentBuilder;
    final descriptionBuilder = widget.descriptionBuilder;
    final description = widget.description;
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
                      Text(
                        'Current $description:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              descriptionBuilder(selectedItem),
                              style: Theme.of(context).textTheme.titleMedium,
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
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        final currentItem = items[index];
                        final (isSelected, content) = contentBuilder(
                          currentItem,
                          selectedItem,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 6, bottom: 12),
                          child: ListTile(
                            title: Text(content),
                            selected: isSelected,
                            trailing: !isSelected
                                ? null
                                : const Icon(
                                    Icons.check,
                                  ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                            ),
                            onTap: () => Navigator.pop(context, currentItem),
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
