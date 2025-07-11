import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timeless_now/home/view/app_drawer.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/view/history_view.dart';
import 'package:timeless_now/meditation_watch/view/watch_view.dart';
import 'package:timeless_now/repositories/app_cache_repository.dart';
import 'package:timeless_now/repositories/meditation_record_repository.dart';

class MeditationWatchPage extends StatelessWidget {
  const MeditationWatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meditationRecordRepository =
        context.read<MeditationRecordRepository>();
    final appCacheRepository = context.read<AppCacheRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => StopwatchBloc(
            appCacheRecordRepository: appCacheRepository,
            meditationRecordRepository: meditationRecordRepository,
          )..add(const InitializeMeditationTimer()),
        ),
        BlocProvider(
          create: (_) => HistoryBloc(
            meditationRecordRepository: meditationRecordRepository,
          )..add(InitializeHistory()),
        ),
      ],
      child: const MeditationWatchView(),
    );
  }
}

class MeditationWatchView extends StatelessWidget {
  const MeditationWatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(
          controller: Provider.of<PageController>(context, listen: false),
        ),
        appBar: AppBar(
          title: const Text('Meditation Watch'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Stopwatch'),
              ),
              Tab(
                child: Text('History'),
              ),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    WatchView(),
                    HistoryView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
