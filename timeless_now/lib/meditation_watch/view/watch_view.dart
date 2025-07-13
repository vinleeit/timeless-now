import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/view/watch_clock_view.dart';
import 'package:timeless_now/meditation_watch/view/watch_summary_view.dart';

class WatchView extends StatelessWidget {
  const WatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconSize: WidgetStateProperty.all(42),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black54,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
        ),
      ),
      child: BlocBuilder<StopwatchBloc, MeditationTimerState>(
        buildWhen: (prev, cur) {
          /// Build when:
          /// - Cur is stopped and prev is running, changing to next view.
          /// - Cur is initial when prev is stopped, changing the view to
          ///   original.
          if (cur is MeditationTimerStopped && prev is MeditationTimerRunning) {
            return true;
          }

          if (cur is MeditationTimerInitial && prev is MeditationTimerStopped) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          return Builder(
            builder: (context) {
              if (state is MeditationTimerStopped) {
                return const WatchSummaryView();
              }
              return const WatchClockView();
            },
          );
        },
      ),
    );
  }
}
