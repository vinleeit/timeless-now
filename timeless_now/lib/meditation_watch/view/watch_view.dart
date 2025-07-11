import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/bloc/stopwatch_bloc.dart';
import 'package:timeless_now/meditation_watch/view/watch_button.dart';
import 'package:timeless_now/models/meditation_record.dart';
import 'package:timeless_now/widgets/dashed_arc.dart';
import 'package:timeless_now/widgets/unimplemented_feature_alert_dialog.dart';

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
      child: Column(
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
          // BlocBuilder<StopwatchBloc, MeditationTimerState>(
          //   builder: (context, state) {
          //     return Visibility(
          //       visible: state is MeditationTimerStopped,
          //       child: Padding(
          //         padding: const EdgeInsets.only(
          //           left: 56,
          //           right: 56,
          //           bottom: 16,
          //         ),
          //         child: TextField(
          //           maxLines: 5,
          //           scrollPhysics: const BouncingScrollPhysics(),
          //           onChanged: (text) {
          //             context
          //                 .read<StopwatchBloc>()
          //                 .add(UpdateNote(note: text));
          //           },
          //           decoration: InputDecoration(
          //             border: const OutlineInputBorder(),
          //             label: const Text('Note'),
          //             hintText: 'Take your note here...',
          //             alignLabelWithHint: true,
          //             floatingLabelAlignment: FloatingLabelAlignment.center,
          //             suffixIcon: InkWell(
          //               borderRadius: BorderRadius.circular(200),
          //               onTap: () {},
          //               child: const Icon(Icons.close),
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          BlocBuilder<StopwatchBloc, MeditationTimerState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is MeditationTimerInitial)
                    WatchButton(
                      text: 'Start',
                      icon: Icons.play_arrow_outlined,
                      onPressed: () =>
                          context.read<StopwatchBloc>().add(const StartTimer()),
                    ),
                  if (state is MeditationTimerRunning)
                    WatchButton(
                      text: 'Stop',
                      icon: Icons.stop_outlined,
                      onPressed: () =>
                          context.read<StopwatchBloc>().add(const StopTimer()),
                    ),
                  if (state is MeditationTimerStopped)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WatchButton(
                          text: 'Finish',
                          icon: Icons.check,
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
                        ),
                        const SizedBox(width: 12),
                        WatchButton(
                          text: 'Details',
                          icon: Icons.info_outline_rounded,
                          onPressed: () =>
                              UnimplementedFeatureAlertDialog.show(context),
                        )
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
