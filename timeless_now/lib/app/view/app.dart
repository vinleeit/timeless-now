import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/app/view/app_route.dart';
import 'package:timeless_now/chant/view/chant_page.dart';
import 'package:timeless_now/l10n/arb/app_localizations.dart';
import 'package:timeless_now/meditation_watch/view/meditation_watch_page.dart';
import 'package:timeless_now/repositories/cache/app_cache_repository.dart';
import 'package:timeless_now/repositories/cache/chant_cache_repository.dart';
import 'package:timeless_now/repositories/cache/watch_cache_repository.dart';
import 'package:timeless_now/repositories/meditation_record_repository.dart';
import 'package:timeless_now/repositories/store_repository.dart';

class App extends StatelessWidget {
  const App({
    required StoreRepository storeRepository,
    super.key,
  }) : _storeRepository = storeRepository;

  final StoreRepository _storeRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StoreRepository>.value(
      value: _storeRepository,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<MeditationRecordRepository>(
            create: (_) =>
                MeditationRecordRepository(store: _storeRepository.store),
          ),
          RepositoryProvider<AppCacheRepository>(
            create: (_) => AppCacheRepository(store: _storeRepository.store),
          ),
          RepositoryProvider<ChantCacheRepository>(
            create: (_) => ChantCacheRepository(store: _storeRepository.store),
          ),
          RepositoryProvider<WatchCacheRepository>(
            create: (_) => WatchCacheRepository(store: _storeRepository.store),
          ),
        ],
        child: Builder(
          builder: (context) {
            return MaterialApp(
              title: 'Tiratana Upasana',
              debugShowCheckedModeBanner: false,
              onGenerateInitialRoutes: (_) {
                var routeName = context
                    .read<AppCacheRepository>()
                    .data
                    .lastVisitedRouteName;

                if (routeName.isEmpty) {
                  routeName = AppRoute.defaultRoute;
                  context.read<AppCacheRepository>()
                    ..data.lastVisitedRouteName = routeName
                    ..flush();
                }

                return [
                  MaterialPageRoute(
                    builder: AppRoute.routes[routeName]!,
                    settings: RouteSettings(name: routeName),
                  ),
                ];
              },
              routes: AppRoute.routes,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                useMaterial3: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
