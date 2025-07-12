import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/utils/time_utils.dart';
import 'package:timeless_now/meditation_watch/widgets/watch_button.dart';
import 'package:timeless_now/models/meditation_record.dart';
import 'package:timeless_now/widgets/dashed_arc.dart';

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
        builder: (context, state) {
          return Builder(
            builder: (context) {
              if (state is MeditationTimerStopped) {
                return Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<StopwatchBloc, MeditationTimerState>(
                        builder: (context, state) {
                          final (elapsed, elapsedUnit) =
                              millisecondsToBiggestTimeUnit(
                            state.elapsed,
                          );
                          return Visibility(
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ).copyWith(bottom: 10, top: 16),
                                  child: Column(
                                    spacing: 16,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd()
                                            .format(state.startTime!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Row(
                                        spacing: 16,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Start Time',
                                              ),
                                              const SizedBox(width: 8),
                                              Chip(
                                                padding: EdgeInsets.zero,
                                                avatar: const Icon(
                                                    Icons.access_time_outlined),
                                                labelPadding:
                                                    const EdgeInsets.only(
                                                        right: 12),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                label: Text(
                                                  DateFormat.Hms().format(
                                                    state.startTime!,
                                                  ),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(height: 0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Duration',
                                              ),
                                              const SizedBox(width: 8),
                                              Chip(
                                                padding: EdgeInsets.zero,
                                                avatar: const Icon(
                                                    Icons.timer_outlined),
                                                labelPadding:
                                                    const EdgeInsets.only(
                                                  right: 12,
                                                ),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                ),
                                                label: Row(
                                                  children: [
                                                    Text(
                                                      elapsed,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(height: 0),
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      elapsedUnit,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(height: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        spacing: 8,
                                        children: [
                                          Text(
                                            'Note',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          TextField(
                                            maxLines: 5,
                                            scrollPhysics:
                                                const BouncingScrollPhysics(),
                                            onChanged: (text) => context
                                                .read<StopwatchBloc>()
                                                .add(UpdateNote(note: text)),
                                            decoration: InputDecoration(
                                              border:
                                                  const OutlineInputBorder(),
                                              label: const Text('Note'),
                                              hintText:
                                                  'Take your note here...',
                                              alignLabelWithHint: true,
                                              suffixIcon: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                onTap: () {},
                                                child: const Icon(Icons.close),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 40,
                                  right: 15,
                                  child: WatchButton(
                                    onPressed: () {
                                      if (state is! MeditationTimerStopped) {
                                        return;
                                      }

                                      context
                                          .read<StopwatchBloc>()
                                          .add(const SaveRecord());
                                      context.read<HistoryBloc>().add(
                                            AddHistory(
                                              meditationRecord:
                                                  MeditationRecord(
                                                meditationStartTime:
                                                    state.startTime!,
                                                meditationDuration:
                                                    state.elapsed,
                                                meditationNote: state.note,
                                              ),
                                            ),
                                          );
                                    },
                                    icon: Icons.check,
                                    text: 'Finish',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  Text(
                                    ':$seconds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
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
                    builder: (context, state) {
                      var label = 'Start';
                      var icon = Icons.play_arrow_outlined;
                      var callback = () =>
                          context.read<StopwatchBloc>().add(const StartTimer());

                      if (state is MeditationTimerRunning) {
                        label = 'Stop';
                        icon = Icons.stop_outlined;
                        callback = () => context
                            .read<StopwatchBloc>()
                            .add(const StopTimer());
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
            },
          );
        },
      ),
    );
  }
}
