import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
import 'package:timeless_now/meditation_watch/widgets/history_card.dart';
import 'package:timeless_now/models/meditation_record.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  List<Widget> createListViewWidgets(
    BuildContext context,
    List<MeditationRecord> meditationRecords,
  ) {
    final result = <Widget>[];
    if (meditationRecords.isEmpty) {
      return result;
    }

    var curDt = '';
    for (final meditationRecord in meditationRecords) {
      final dt = DateFormat.yMMMd().format(
        meditationRecord.meditationStartTime,
      );

      if (curDt != dt) {
        result.add(
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 2 / 3,
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        dt,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: Colors.black87),
                      ),
                    ),
                    const Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        curDt = dt;
      }

      result.add(
        HistoryCard(
          meditationRecord: meditationRecord,
          onDelete: (meditationRecord) {
            context.read<HistoryBloc>().add(
                  RemoveHistory(
                    id: meditationRecord.id,
                  ),
                );
          },
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is! HistoryReadyState || state.meditationRecords.isEmpty) {
          return const Center(
            child: Text('No data'),
          );
        }

        final widgets = createListViewWidgets(
          context,
          state.meditationRecords,
        );

        return ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int index) {
            return widgets.elementAt(index);
          },
          padding: const EdgeInsets.symmetric(vertical: 16),
        );
      },
    );
  }
}
