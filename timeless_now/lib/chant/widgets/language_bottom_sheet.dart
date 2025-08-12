import 'package:timeless_now/chant/widgets/item_list_bottom_sheet.dart';

class LanguageBottomSheet extends ItemListBottomSheet<String> {
  LanguageBottomSheet({
    required String selectedIso,
    required List<String> isos,
    super.key,
  }) : super(
          selectedItem: selectedIso,
          items: isos,
          descriptionBuilder: (selectedLanguage) => selectedLanguage,
          contentBuilder: (currentLanguage, selectedLanguage) {
            return (currentLanguage == selectedLanguage, currentLanguage);
          },
          description: 'language',
        );
}
