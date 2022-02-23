part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleGenerate extends PuzzleEvent {
  const PuzzleGenerate({this.isNewGame = false}) : super();
  final bool isNewGame;

  @override
  List<Object> get props => [isNewGame];
}

class PuzzleRestart extends PuzzleEvent {
  const PuzzleRestart() : super();
}

class PuzzleSolved extends PuzzleEvent {
  const PuzzleSolved() : super();
}

class PuzzleTileMoved extends PuzzleEvent {
  const PuzzleTileMoved(this.direction) : super();
  final Direction direction;

  @override
  List<Object> get props => [direction];
}

class PuzzleTrainingStarted extends PuzzleEvent {
  const PuzzleTrainingStarted() : super();
}

class PuzzleTrialInitialized extends PuzzleEvent {
  const PuzzleTrialInitialized() : super();
}

class PuzzleTrialStarted extends PuzzleEvent {
  const PuzzleTrialStarted() : super();
}

class PuzzleTrialFinished extends PuzzleEvent {
  const PuzzleTrialFinished() : super();
}
