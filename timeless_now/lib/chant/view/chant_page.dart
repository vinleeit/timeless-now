import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/chant/bloc/chant_bloc.dart';
import 'package:timeless_now/chant/view/chant_view.dart';
import 'package:timeless_now/repositories/app_cache_repository.dart';

class ChantPage extends StatelessWidget {
  const ChantPage({super.key});

  static String get routeName => '/chant';

  @override
  Widget build(BuildContext context) {
    final appCacheRepository = context.read<AppCacheRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChantBloc(
            appCacheRepository: appCacheRepository,
          )..add(InitializeChant()),
        ),
      ],
      child: const ChantView(),
    );
  }
}
