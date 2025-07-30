import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timeless_now/chant/models/chant.dart';
import 'package:timeless_now/repositories/cache/chant_cache_repository.dart';

part 'chant_event.dart';
part 'chant_state.dart';

class ChantBloc extends Bloc<ChantEvent, ChantState> {
  ChantBloc({
    required ChantCacheRepository chantCacheRepository,
  })  : _chantCacheRepository = chantCacheRepository,
        super(const ChantInitialState()) {
    on<InitializeChant>(_onInitializeChant);
    on<LoadChantFromJsonFile>(_onLoadChantFromJsonFile);
    on<ChangeChant>(_onChangeChant);
    on<ChangeChantContent>(_onChangeChantContent);
    on<ChangeFontSize>(_onChangeFontSize);
  }

  final ChantCacheRepository _chantCacheRepository;

  FutureOr<void> _onInitializeChant(
    InitializeChant event,
    Emitter<ChantState> emit,
  ) {
    final filePath = _chantCacheRepository.data.chantJsonPath;
    if (filePath.isNotEmpty) {
      final file = File(filePath);
      if (!file.existsSync()) {
        // Cached file path does not exist
        _chantCacheRepository
          ..data.chantJsonPath = ''
          ..flush();
        // TODO: show error
      } else {
        try {
          final contentStr = file.readAsStringSync();
          final chants = (jsonDecode(contentStr) as List)
              .map(
                (e) => Chant.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
          emit(
            ChantReadyState(
              chants: chants,
              currentChantIndex: 0,
              fontSize: state.fontSize,
            ),
          );
        } catch (e) {
          // TODO: show error
        }
      }
    }
  }

  FutureOr<void> _onLoadChantFromJsonFile(
    LoadChantFromJsonFile event,
    Emitter<ChantState> emit,
  ) {
    final filePath = event.filePath;

    if (filePath.isEmpty) {
      return null;
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      // TODO: show error
      return null;
    }

    try {
      final contentStr = file.readAsStringSync();
      final chants = (jsonDecode(contentStr) as List)
          .map(
            (e) => Chant.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
      _chantCacheRepository
        ..data.chantJsonPath = filePath
        ..flush();

      emit(
        ChantReadyState(
          chants: chants,
          currentChantIndex: 0,
          fontSize: state.fontSize,
        ),
      );
    } catch (e) {
      // TODO: show error
    }
  }

  FutureOr<void> _onChangeChant(
    ChangeChant event,
    Emitter<ChantState> emit,
  ) {
    if (event.index < 0 || event.index >= state.chants.length) {
      // TODO: show error
      return null;
    }
    emit(
      ChantReadyState(
        chants: [...state.chants],
        currentChantIndex: event.index,
        fontSize: state.fontSize,
      ),
    );
  }

  FutureOr<void> _onChangeChantContent(
    ChangeChantContent event,
    Emitter<ChantState> emit,
  ) {
    final currentChant = state.currentChant;
    if (currentChant != null) {
      currentChant.selectedContent = currentChant.contents.singleWhere(
        (element) => element.iso == event.iso,
      );
    }

    emit(
      ChantReadyState(
        chants: [...state.chants],
        currentChantIndex: state.currentChantIndex,
        fontSize: state.fontSize,
      ),
    );
  }

  FutureOr<void> _onChangeFontSize(
    ChangeFontSize event,
    Emitter<ChantState> emit,
  ) {
    emit(
      ChantReadyState(
        chants: [...state.chants],
        currentChantIndex: state.currentChantIndex,
        fontSize: event.fontSize,
      ),
    );
  }
}
