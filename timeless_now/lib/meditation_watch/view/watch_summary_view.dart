import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/utils/time_utils.dart';
import 'package:timeless_now/meditation_watch/widgets/watch_button.dart';
import 'package:timeless_now/models/meditation_record.dart';

class WatchSummaryView extends StatefulWidget {
  const WatchSummaryView({super.key});

  @override
  State<WatchSummaryView> createState() => _WatchSummaryViewState();
}

class _WatchSummaryViewState extends State<WatchSummaryView> {
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ).copyWith(bottom: 10, top: 16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  BlocBuilder<StopwatchBloc, MeditationTimerState>(
                    buildWhen: (prev, cur) => false,
                    builder: (context, state) {
                      return Text(
                        DateFormat.yMMMd().format(state.startTime!),
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    },
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Time',
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            padding: EdgeInsets.zero,
                            avatar: const Icon(Icons.access_time_outlined),
                            labelPadding: const EdgeInsets.only(right: 12),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            label: BlocBuilder<StopwatchBloc,
                                MeditationTimerState>(
                              buildWhen: (prev, cur) => false,
                              builder: (context, state) {
                                final startTimeStr = DateFormat.Hms().format(
                                  state.startTime!,
                                );
                                return Text(
                                  startTimeStr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(height: 0),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Duration',
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            padding: EdgeInsets.zero,
                            avatar: const Icon(Icons.timer_outlined),
                            labelPadding: const EdgeInsets.only(
                              right: 12,
                            ),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            label: BlocBuilder<StopwatchBloc,
                                MeditationTimerState>(
                              buildWhen: (prev, cur) => false,
                              builder: (context, state) {
                                final (elapsed, elapsedUnit) =
                                    millisecondsToBiggestTimeUnit(
                                  state.elapsed,
                                );
                                return Row(
                                  spacing: 3,
                                  children: [
                                    Text(
                                      elapsed,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(height: 0),
                                    ),
                                    Text(
                                      elapsedUnit,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(height: 0),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  Text(
                    'Note',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextField(
                    controller: _noteController,
                    maxLines: 5,
                    scrollPhysics: const BouncingScrollPhysics(),
                    onChanged: (text) => context
                        .read<StopwatchBloc>()
                        .add(UpdateNote(note: text)),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text('Note'),
                      hintText: 'Take your note here...',
                      alignLabelWithHint: true,
                      suffixIcon: InkWell(
                        borderRadius: BorderRadius.circular(200),
                        onTap: () {
                          context.read<StopwatchBloc>().add(const UpdateNote());
                          _noteController.clear();
                        },
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
          child: BlocBuilder<StopwatchBloc, MeditationTimerState>(
            buildWhen: (prev, cur) {
              /// Build when:
              /// - Cur is stopped.
              /// - Change in note when prev is stopped.
              if (cur is! MeditationTimerStopped) {
                return false;
              }

              if (prev is MeditationTimerStopped && prev.note == cur.note) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              return WatchButton(
                onPressed: (state is! MeditationTimerStopped)
                    ? null
                    : () {
                        context.read<StopwatchBloc>().add(const SaveRecord());
                        context.read<HistoryBloc>().add(
                              AddHistory(
                                meditationRecord: MeditationRecord(
                                  meditationStartTime: state.startTime!,
                                  meditationDuration: state.elapsed,
                                  meditationNote: state.note,
                                ),
                              ),
                            );
                      },
                icon: Icons.check,
                text: 'Finish',
              );
            },
          ),
        ),
      ],
    );
  }
}
