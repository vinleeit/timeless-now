import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/utils/time_utils.dart';
import 'package:timeless_now/meditation_watch/widgets/watch_button.dart';
import 'package:timeless_now/widgets/dashed_arc.dart';


class WatchClockView extends StatelessWidget {
  const WatchClockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: DottedBorder(
                numberOfStories: 70,
                spaceLength: 5,
                strokeWidth: 6,
                color: Colors.grey,
              ),
              size: const Size.square(250),
            ),
            const CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              constraints: BoxConstraints(
                minWidth: 250,
                minHeight: 250,
              ),
              strokeWidth: 14,
              value: 0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Elapsed time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                BlocBuilder<StopwatchBloc, MeditationTimerState>(
                  buildWhen: (prev, cur) {
                    /// Build when:
                    /// - Timer is initial after stopped, reset the time to 0
                    /// - Timer is running, updating the time
                    if (cur is MeditationTimerRunning) {
                      return true;
                    }

                    if (cur is MeditationTimerInitial) {
                      return prev is MeditationTimerStopped;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    final elapsed = state.elapsed;
                    final (hours, minutes, seconds) =
                        millisecondsToHMS(elapsed);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$hours:$minutes',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        Text(
                          ':$seconds',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        BlocBuilder<StopwatchBloc, MeditationTimerState>(
          buildWhen: (prev, cur) {
            /// Build when:
            /// - Stopwatch is stopped, changing 'Start' to 'Stop' label.
            /// - Stopwatch is back to initial after stopped, changing 'Stop'
            ///   back to 'Start' label.
            if (cur is MeditationTimerInitial) {
              return prev is MeditationTimerStopped;
            }

            if (cur is MeditationTimerRunning) {
              return prev is! MeditationTimerRunning;
            }

            return false;
          },
          builder: (context, state) {
            var label = 'Start';
            var icon = Icons.play_arrow_outlined;
            var callback =
                () => context.read<StopwatchBloc>().add(const StartTimer());

            if (state is MeditationTimerRunning) {
              label = 'Stop';
              icon = Icons.stop_outlined;
              callback =
                  () => context.read<StopwatchBloc>().add(const StopTimer());
            }
            return WatchButton(
              onPressed: callback,
              icon: icon,
              text: label,
            );
          },
        ),
      ],
    );
  }
}
