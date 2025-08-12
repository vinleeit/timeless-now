import 'package:flutter/material.dart';
import 'package:timeless_now/app/app.dart';
import 'package:timeless_now/bootstrap.dart';
import 'package:timeless_now/repositories/store_repository.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final storeRepository = StoreRepository();
    await storeRepository.initStore();

    return App(
      storeRepository: storeRepository,
    );
  });
}
