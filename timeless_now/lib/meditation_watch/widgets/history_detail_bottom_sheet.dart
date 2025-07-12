import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/meditation_watch/utils/time_utils.dart';
import 'package:timeless_now/models/meditation_record.dart';

class HistoryDetailBottomSheet extends StatefulWidget {
  const HistoryDetailBottomSheet({
    required this.meditationRecord,
    super.key,
  });

  final MeditationRecord meditationRecord;

  @override
  State<HistoryDetailBottomSheet> createState() =>
      _HistoryDetailBottomSheetState();
}

class _HistoryDetailBottomSheetState extends State<HistoryDetailBottomSheet>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final meditationRecord = widget.meditationRecord;

    final dateStr = DateFormat.yMMMd().format(
      meditationRecord.meditationStartTime,
    );
    final timeStr =
        DateFormat.Hms().format(meditationRecord.meditationStartTime);

    final (durationStr, durationUnit) = millisecondsToBiggestTimeUnit(
      meditationRecord.meditationDuration,
    );

    return BottomSheet(
      onClosing: () {},
      animationController: BottomSheet.createAnimationController(this),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 3 / 4,
      ),
      builder: (context) {
        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.titleLarge,
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
                            label: Text(
                              timeStr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(height: 0),
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
                            labelPadding: const EdgeInsets.only(right: 12),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            label: Row(
                              children: [
                                Text(
                                  durationStr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(height: 0),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  durationUnit,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Text(
                        'Note',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        meditationRecord.meditationNote.isEmpty
                            ? '(empty)'
                            : meditationRecord.meditationNote,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
