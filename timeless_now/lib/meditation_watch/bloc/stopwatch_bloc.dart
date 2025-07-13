import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeless_now/models/meditation_record.dart';
import 'package:timeless_now/objectbox.g.dart';
import 'package:timeless_now/repositories/app_cache_repository.dart';
import 'package:timeless_now/repositories/meditation_record_repository.dart';

part 'stopwatch_event.dart';

part 'stopwatch_state.dart';

class StopwatchBloc extends Bloc<MeditationTimerEvent, MeditationTimerState> {
  StopwatchBloc({
    required MeditationRecordRepository meditationRecordRepository,
    required AppCacheRepository appCacheRecordRepository,
  })  : _meditationRecordRepository = meditationRecordRepository,
        _appCacheRepository = appCacheRecordRepository,
        super(const MeditationTimerInitial()) {
    on<InitializeMeditationTimer>(_onInitializeData);
    on<StartTimer>(_onStartTimer);
    on<_TimerTick>(_onTimerTick);
    on<StopTimer>(_onStopTimer);
    on<UpdateNote>(_onUpdateNote);
    on<SaveRecord>(_onSaveRecord);

    final meditationRecords = _meditationRecordRepository.box
        .query()
        .order(MeditationRecord_.meditationStartTime)
        .build()
        .find();

    final groupedMeditationRecord = <String, List<MeditationRecord>>{};
    for (final meditationRecord in meditationRecords) {
      final startDateStr = DateFormat.yMMMd().format(
        meditationRecord.meditationStartTime,
      );
      if (!groupedMeditationRecord.containsKey(startDateStr)) {
        groupedMeditationRecord[startDateStr] = [];
      }
      groupedMeditationRecord[startDateStr]?.add(meditationRecord);
    }
  }

  late final MeditationRecordRepository _meditationRecordRepository;
  late final AppCacheRepository _appCacheRepository;
  static const int _tickDuration = 1000; // milliseconds
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStartTimer(StartTimer event, Emitter<MeditationTimerState> emit) {
    if (state is MeditationTimerInitial) {
      final startTime = DateTime.now();
      _appCacheRepository
        ..data.cachedMeditationWatchStartTime = startTime
        ..flush();
      emit(
        MeditationTimerRunning(
          startTime: startTime,
          elapsed: state.elapsed,
        ),
      );
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(milliseconds: _tickDuration),
        (timer) => add(_TimerTick(elapsed: state.elapsed + _tickDuration)),
      );
    }
  }

  void _onTimerTick(_TimerTick event, Emitter<MeditationTimerState> emit) {
    emit(
      MeditationTimerRunning(
        startTime: state.startTime,
        elapsed: event.elapsed,
      ),
    );
  }

  void _onStopTimer(StopTimer event, Emitter<MeditationTimerState> emit) {
    if (state is MeditationTimerRunning) {
      _timer?.cancel();
      _appCacheRepository
        ..data.cachedMeditationWatchStartTime = null
        ..flush();
      emit(
        MeditationTimerStopped(
          startTime: state.startTime,
          elapsed: state.elapsed,
          note: '',
        ),
      );
    }
  }

  void _onUpdateNote(UpdateNote event, Emitter<MeditationTimerState> emit) {
    if (state is MeditationTimerStopped) {
      print(event.note);
      final currentState = state as MeditationTimerStopped;
      emit(
        MeditationTimerStopped(
          startTime: currentState.startTime,
          elapsed: currentState.elapsed,
          note: event.note,
        ),
      );
    }
  }

  Future<void> _onSaveRecord(
    SaveRecord event,
    Emitter<MeditationTimerState> emit,
  ) async {
    emit(const MeditationTimerInitial());
  }

  FutureOr<void> _onInitializeData(
    InitializeMeditationTimer event,
    Emitter<MeditationTimerState> emit,
  ) {
    final startTime = _appCacheRepository.data.cachedMeditationWatchStartTime;
    if (startTime == null) {
      return null;
    }
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    emit(
      MeditationTimerRunning(
        startTime: startTime,
        elapsed: elapsed,
      ),
    );
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: _tickDuration),
      (timer) {
        add(_TimerTick(elapsed: state.elapsed + _tickDuration));
      },
    );
  }
}
