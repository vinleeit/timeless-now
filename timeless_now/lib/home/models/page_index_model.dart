import 'package:flutter/material.dart';

class PageIndexModel extends ChangeNotifier {
  PageIndexModel({
    this.index = 1,
  });

  int index;

  void updateIndex(int newIndex) {
    if (index == newIndex) {
      return;
    }
    index = newIndex;
    notifyListeners();
  }
}
