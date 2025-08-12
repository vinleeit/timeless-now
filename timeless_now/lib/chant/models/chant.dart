class Chant {
  Chant({
    required this.id,
    required this.contents,
  }) : assert(contents.isNotEmpty, 'contents must not be empty') {
    selectedContent = contents.singleWhere((element) => element.isDefault);
  }

  Chant.fromJson(
    Map<String, dynamic> value,
  )   : id = int.parse(value['id'].toString()),
        contents = (value['contents'] as List)
            .map((e) => ChantContent.fromJson(e as Map<String, dynamic>))
            .toList() {
    selectedContent = contents.singleWhere((element) => element.isDefault);
  }

  final int id;
  final List<ChantContent> contents;
  late ChantContent selectedContent;

  ChantContent get defaultContent {
    return contents.singleWhere((element) => element.isDefault);
  }

  bool setSelectedContentByIso(String iso) {
    if (selectedContent.iso == iso) {
      return false;
    }

    for (final content in contents) {
      if (content.iso == iso) {
        return true;
      }
    }
    return false;
  }
}

class ChantContent {
  ChantContent({
    required this.iso,
    required this.title,
    required this.content,
    this.isDefault = false,
  });

  ChantContent.fromJson(Map<String, dynamic> value)
      : iso = value['iso'].toString(),
        title = value['title'].toString(),
        content = value['content'].toString(),
        isDefault = bool.parse(value['isDefault'].toString());

  final String iso;
  final String title;
  final String content;
  final bool isDefault;
}
