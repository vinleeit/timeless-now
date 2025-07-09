import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/models/meditation_record.dart';

class WatchView extends StatelessWidget {
  const WatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Elapsed time:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  BlocBuilder<StopwatchBloc, MeditationTimerState>(
                    builder: (context, state) {
                      final elapsed = state.elapsed;
                      final hours = ((elapsed / 1000) / 3600)
                           .floor()
                          .toString()
                          .padLeft(2, '0');
                      final minutes = ((elapsed / 1000) / 60 % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      final seconds = ((elapsed / 1000) % 60)
                          .floor()
                          .toString()
                          .padLeft(2, '0');
                      return Text(
                        '$hours:$minutes:$seconds',
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 5,
              child: BlocBuilder<StopwatchBloc, MeditationTimerState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state is MeditationTimerStopped,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 56,
                        right: 56,
                        bottom: 16,
                      ),
                      child: TextField(
                        maxLines: 5,
                        scrollPhysics: const BouncingScrollPhysics(),
                        onChanged: (text) {
                          context
                              .read<StopwatchBloc>()
                              .add(UpdateNote(note: text));
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: const Text('Note'),
                          hintText: 'Take your note here...',
                          alignLabelWithHint: true,
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          suffixIcon: InkWell(
                            borderRadius: BorderRadius.circular(200),
                            onTap: () {},
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<StopwatchBloc, MeditationTimerState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: (View.of(context).viewInsets.bottom > 0)
                        ? constraint.maxHeight * 0.08
                        : constraint.maxHeight * 0.15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is MeditationTimerInitial)
                        IconButton(
                          onPressed: () => context
                              .read<StopwatchBloc>()
                              .add(const StartTimer()),
                          icon: const Icon(
                            Icons.play_arrow_outlined,
                          ),
                          tooltip: 'Start',
                        ),
                      if (state is MeditationTimerRunning)
                        IconButton(
                          onPressed: () => context
                              .read<StopwatchBloc>()
                              .add(const StopTimer()),
                          icon: const Icon(
                            Icons.stop_outlined,
                          ),
                          tooltip: 'Stop',
                        ),
                      if (state is MeditationTimerStopped)
                        IconButton(
                          onPressed: () {
                            context
                                .read<StopwatchBloc>()
                                .add(const SaveRecord());
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
                          icon: const Icon(
                            Icons.check,
                          ),
                          tooltip: 'Submit',
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
