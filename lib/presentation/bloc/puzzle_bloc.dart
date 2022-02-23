import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isolated_worker/isolated_worker.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:just_look_up/core/constants.dart';
import 'package:just_look_up/model/direction.dart';
import 'package:just_look_up/model/position.dart';
import 'package:just_look_up/services/apis.dart';
part 'puzzle_event.dart';
part 'puzzle_state.dart';

List<Position>? _nextObstacles;
Position? _nextGoalPosition;
bool _loaded = false;

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(const PuzzleState()) {
    on<PuzzleGenerate>(_onPuzzleGenerate);
    on<PuzzleRestart>(_onPuzzleRestart);
    on<PuzzleSolved>(_onPuzzleSolved);
    on<PuzzleTileMoved>(_onPuzzleTileMoved);
    on<PuzzleTrainingStarted>(_onPuzzleTrainingStarted);
    on<PuzzleTrialInitialized>(_onPuzzleTrialInitialized);
    on<PuzzleTrialStarted>(_onPuzzleTrialStarted);
    on<PuzzleTrialFinished>(_onPuzzleTrialFinished);

    _load();
  }
  Future<void> _load() async {
    if (kIsWeb) {
      _loaded = await JsIsolatedWorker().importScripts(['apis.js']);
    }
  }

  Future<void> _onPuzzleGenerate(
      PuzzleGenerate event, Emitter<PuzzleState> emit) async {
    List<Position> obstacles;
    Position goalPosition;

    if (_nextGoalPosition == null ||
        _nextGoalPosition == state.goalPosition ||
        event.isNewGame) {
      final puzzle = generatePuzzle(<String, int>{
        'start_x': state.currentPosition.x,
        'start_y': state.currentPosition.y,
        'min_depth': min(minPuzzleDepth + state.score, maxPuzzleDepth),
      });
      obstacles = puzzle['obstacles']! as List<Position>;
      goalPosition = puzzle['goal_position'] as Position;
    } else {
      obstacles = _nextObstacles!;
      goalPosition = _nextGoalPosition!;
    }

    if (state.puzzleStatus == PuzzleStatus.timeTrialInitial) {
      await for (final s in stream) {
        if (s.puzzleStatus == PuzzleStatus.timeTrialInProgress) {
          break;
        }
      }
    }

    emit(state.copyWith(
      startPosition: state.goalPosition,
      goalPosition: goalPosition,
      obstacles: obstacles,
    ));

    if (kIsWeb) {
      if (_loaded) {
        final puzzle = await JsIsolatedWorker().run(
          functionName: 'generatePuzzle',
          arguments: <String, int>{
            'start_x': state.goalPosition.x,
            'start_y': state.goalPosition.y,
            'min_depth': min(minPuzzleDepth + state.score + 1, maxPuzzleDepth),
          },
        ) as String;
        final map = jsonDecode(puzzle) as Map<String, dynamic>;
        final resultGoalPosition = map['goal_position'] as Map<String, dynamic>;
        _nextObstacles = [];
        for (final obstacle in map['obstacles']) {
          final x = (obstacle as Map)['x'] as int;
          final y = obstacle['y'] as int;
          _nextObstacles!.add(Position(x, y));
        }
        _nextGoalPosition = Position(
            resultGoalPosition['x'] as int, resultGoalPosition['y'] as int);
      } else {
        if (kDebugMode) {
          print('Web worker is not available :(');
        }
      }
    } else {
      // ignore: unawaited_futures
      IsolatedWorker().run(generatePuzzle, <String, int>{
        'start_x': state.goalPosition.x,
        'start_y': state.goalPosition.y,
        'min_depth': min(minPuzzleDepth + state.score + 1, maxPuzzleDepth),
      }).then((puzzle) {
        _nextObstacles = puzzle['obstacles']! as List<Position>;
        _nextGoalPosition = puzzle['goal_position'] as Position;
      });
    }
  }

  Future<void> _onPuzzleSolved(
      PuzzleSolved event, Emitter<PuzzleState> emit) async {
    emit(state.copyWith(obstacles: [], score: state.score + 1));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    add(const PuzzleGenerate());
  }

  Future<void> _onPuzzleTileMoved(
      PuzzleTileMoved event, Emitter<PuzzleState> emit) async {
    final position =
        movePosition(state.currentPosition, event.direction, state.obstacles);
    emit(state.copyWith(currentPosition: position));
    if (state.currentPosition == state.goalPosition) {
      add(const PuzzleSolved());
    }
  }

  void _onPuzzleTrainingStarted(
      PuzzleTrainingStarted event, Emitter<PuzzleState> emit) {
    emit(const PuzzleState());
    add(const PuzzleGenerate(isNewGame: true));
  }

  Future<void> _onPuzzleTrialInitialized(
      PuzzleTrialInitialized event, Emitter<PuzzleState> emit) async {
    emit(const PuzzleState()
        .copyWith(puzzleStatus: PuzzleStatus.timeTrialInitial));
    add(const PuzzleGenerate(isNewGame: true));
  }

  void _onPuzzleTrialStarted(
      PuzzleTrialStarted event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(puzzleStatus: PuzzleStatus.timeTrialInProgress));
  }

  void _onPuzzleTrialFinished(
      PuzzleTrialFinished event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(puzzleStatus: PuzzleStatus.timeTrialFinished));
  }

  void _onPuzzleRestart(PuzzleRestart event, Emitter<PuzzleState> emit) {
    emit(state.copyWith(currentPosition: state.startPosition));
  }
}
