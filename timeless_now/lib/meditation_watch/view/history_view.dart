import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/meditation_watch/bloc/history_bloc.dart';
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
      final duration = meditationRecord.meditationDuration / 1000;
      var durationUnit = 'sec';
      var durationStr = duration.toStringAsFixed(0);
      if (duration > 3600) {
        durationUnit = 'hour';
        durationStr = (duration / 3600).toStringAsFixed(1);
      } else if (duration > 60) {
        durationUnit = 'min';
        durationStr = (duration / 60).toStringAsFixed(0);
      }

      final dt = DateFormat.yMMMd().format(
        meditationRecord.meditationStartTime,
      );
      if (curDt != dt) {
        result.add(
          Text(
            dt,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        );
        curDt = dt;
      }
      result.add(
        ListTile(
          key: Key(meditationRecord.id.toString()),
          title: Text(
            DateFormat.Hms().format(
              meditationRecord.meditationStartTime,
            ),
          ),
          dense: true,
          leading: CircleAvatar(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  durationStr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 0),
                ),
                Text(
                  durationUnit,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        height: 0,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
          ),
          subtitle: meditationRecord.meditationNote.isEmpty
              ? null
              : Text(meditationRecord.meditationNote),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_horiz),
            position: PopupMenuPosition.under,
            tooltip: 'Actions',
            itemBuilder: (context) {
              return [
                PopupMenuItem<String>(
                  value: 'Delete',
                  child: const Text('Delete'),
                  onTap: () => context.read<HistoryBloc>().add(
                        RemoveHistory(
                          id: meditationRecord.id,
                        ),
                      ),
                ),
              ];
            },
          ),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is! HistoryReadyState) {
          return const Text('No data');
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
