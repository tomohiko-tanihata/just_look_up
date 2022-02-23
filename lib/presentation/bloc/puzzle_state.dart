part of 'puzzle_bloc.dart';

enum PuzzleStatus {
  trainingInProgress,
  timeTrialInitial,
  timeTrialInProgress,
  timeTrialFinished
}

class PuzzleState extends Equatable {
  const PuzzleState({
    this.puzzleStatus = PuzzleStatus.trainingInProgress,
    this.startPosition = const Position(0, 0),
    this.currentPosition = const Position(0, 0),
    this.goalPosition = const Position(0, 0),
    this.obstacles = const [],
    this.score = 0,
  });

  final PuzzleStatus puzzleStatus;
  final Position startPosition;
  final Position currentPosition;
  final Position goalPosition;
  final List<Position> obstacles;
  final int score;

  PuzzleState copyWith({
    PuzzleStatus? puzzleStatus,
    Position? startPosition,
    Position? currentPosition,
    Position? goalPosition,
    List<Position>? obstacles,
    int? score,
    bool? isInputActivated,
  }) {
    return PuzzleState(
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      startPosition: startPosition ?? this.startPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      goalPosition: goalPosition ?? this.goalPosition,
      obstacles: obstacles ?? this.obstacles,
      score: score ?? this.score,
    );
  }

  @override
  List<Object> get props => [
        puzzleStatus,
        startPosition,
        currentPosition,
        goalPosition,
        obstacles,
        score,
      ];

  bool get isInputActivated =>
      puzzleStatus == PuzzleStatus.trainingInProgress ||
      puzzleStatus == PuzzleStatus.timeTrialInProgress;
}
