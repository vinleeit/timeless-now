import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/models/meditation_record.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    required this.meditationRecord,
    this.cardPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.cardMargin = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.contentPadding = const EdgeInsets.only(top: 6, left: 16, right: 16),
    this.leadingSpacing = 10,
    this.trailingSpacing = 8,
    this.onDelete,
    this.onDetail,
    super.key,
  });

  final MeditationRecord meditationRecord;
  final EdgeInsets cardPadding;
  final EdgeInsets cardMargin;
  final EdgeInsets contentPadding;
  final double leadingSpacing;
  final double trailingSpacing;
  final void Function(MeditationRecord)? onDelete;
  final void Function(MeditationRecord)? onDetail;

  @override
  Widget build(BuildContext context) {
    final duration = meditationRecord.meditationDuration / 1000;
    var durationUnit = 'second${duration == 1 ? '' : 's'}';
    var durationStr = duration.toStringAsFixed(0);
    if (duration > 3600) {
      final dur = duration / 3600;
      durationUnit = 'hour${dur == 1 ? '' : 's'}';
      durationStr = dur.toStringAsFixed(1);
    } else if (duration > 60) {
      final dur = duration / 60;
      durationUnit = 'minutes${dur == 1 ? '' : 's'}';
      durationStr = dur.toStringAsFixed(0);
    }

    return Card(
      key: Key(meditationRecord.id.toString()),
      margin: cardMargin,
      clipBehavior: Clip.hardEdge,
      child: Material(
        shape: Border(
          left: BorderSide(
            width: 6,
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Padding(
          padding: cardPadding.copyWith(
            bottom: (meditationRecord.meditationNote.isEmpty)
                ? cardPadding.bottom
                : cardPadding.bottom - 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 36,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: leadingSpacing,
                        right: trailingSpacing,
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.Hms().format(
                              meditationRecord.meditationStartTime,
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
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
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    position: PopupMenuPosition.under,
                    tooltip: 'Actions',
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'Detail',
                          onTap: onDetail == null
                              ? null
                              : () => onDetail!(meditationRecord),
                          child: const Text('Detail'),
                        ),
                        PopupMenuItem<String>(
                          value: 'Delete',
                          onTap: (onDelete == null)
                              ? null
                              : () => onDelete!(meditationRecord),
                          child: const Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              if (meditationRecord.meditationNote.isEmpty)
                const SizedBox()
              else
                Padding(
                  padding: contentPadding,
                  child: Text(
                    meditationRecord.meditationNote,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
