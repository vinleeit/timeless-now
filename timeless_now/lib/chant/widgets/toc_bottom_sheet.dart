import 'package:timeless_now/chant/models/chant.dart';
import 'package:timeless_now/chant/widgets/item_list_bottom_sheet.dart';

class TocBottomSheet extends ItemListBottomSheet<Chant> {
  TocBottomSheet({
    required Chant selectedChant,
    required List<Chant> chants,
    super.key,
  }) : super(
          selectedItem: selectedChant,
          items: chants,
          descriptionBuilder: (selectedItem) =>
              selectedItem.selectedContent.title,
          contentBuilder: (currentItem, selectedItem) {
            return (
              currentItem.id == selectedItem.id,
              currentItem.selectedContent.title,
            );
          },
          description: 'chant',
        );
}
