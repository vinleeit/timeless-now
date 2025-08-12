import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timeless_now/models/meditation_record.dart';
import 'package:timeless_now/objectbox.g.dart';
import 'package:timeless_now/repositories/meditation_record_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required MeditationRecordRepository meditationRecordRepository,
  })  : _meditationRecordRepository = meditationRecordRepository,
        super(const HistoryInitialState()) {
    on<InitializeHistory>(_onInitializeData);
    on<AddHistory>(_onAddHistory);
    on<RemoveHistory>(_onRemoveHistory);
  }

  final MeditationRecordRepository _meditationRecordRepository;

  void _onInitializeData(InitializeHistory event, Emitter<HistoryState> emit) {
    final meditationRecords = _meditationRecordRepository.box
        .query()
        .order(MeditationRecord_.meditationStartTime, flags: Order.descending)
        .build()
        .find();

    // final groupedMeditationRecord = <String, List<MeditationRecord>>{};
    // for (final meditationRecord in meditationRecords) {
    //   final startDateStr = DateFormat.yMMMd().format(
    //     meditationRecord.meditationStartTime,
    //   );
    //   if (!groupedMeditationRecord.containsKey(startDateStr)) {
    //     groupedMeditationRecord[startDateStr] = [];
    //   }
    //   groupedMeditationRecord[startDateStr]?.add(meditationRecord);
    // }
    emit(
      HistoryReadyState(
        meditationRecords: meditationRecords,
      ),
    );
  }

  FutureOr<void> _onAddHistory(AddHistory event, Emitter<HistoryState> emit) {
    final newMeditationRecord = event.meditationRecord;
    _meditationRecordRepository.box.put(newMeditationRecord);

    if (state is! HistoryReadyState) {
      emit(
        HistoryReadyState(meditationRecords: [newMeditationRecord]),
      );
      return null;
    }
    emit(
      HistoryReadyState(
        meditationRecords: [
          newMeditationRecord,
          ...(state as HistoryReadyState).meditationRecords,
        ],
      ),
    );
  }

  FutureOr<void> _onRemoveHistory(
    RemoveHistory event,
    Emitter<HistoryState> emit,
  ) {
    _meditationRecordRepository.box.remove(event.id);

    if (state is HistoryReadyState) {
      emit(
        HistoryReadyState(
          meditationRecords: [
            ...(state as HistoryReadyState).meditationRecords,
          ]..removeWhere((element) => element.id == event.id),
        ),
      );
    }
  }
}
