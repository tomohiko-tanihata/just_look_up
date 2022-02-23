import 'dart:collection';
import 'dart:math';

import 'package:just_look_up/core/constants.dart';
import 'package:just_look_up/model/direction.dart';
import 'package:just_look_up/model/position.dart';
import 'package:just_look_up/services/node.dart';

Position movePosition(
  Position previous,
  Direction direction,
  List<Position> obstacles,
) {
  int x;
  int y;

  if (direction.axis == Axis.x) {
    if (direction.sign == Sign.positive) {
      x = gridNum - 1;
      var candidate = Position(x, previous.y);
      final candidates = (obstacles
          .where((e) => (e.y == previous.y && e.x > previous.x))
          .toList()
        ..sort((a, b) => a.x.compareTo(b.x)));
      if (candidates.isNotEmpty) {
        candidate = candidates.first;
        x = candidate.x - 1;
      }
    } else {
      x = 0;
      var candidate = Position(x, previous.y);
      final candidates = (obstacles
          .where((e) => (e.y == previous.y && e.x < previous.x))
          .toList()
        ..sort((a, b) => -1 * a.x.compareTo(b.x)));
      if (candidates.isNotEmpty) {
        candidate = candidates.first;
        x = candidate.x + 1;
      }
    }
    y = previous.y;
  } else {
    if (direction.sign == Sign.positive) {
      y = gridNum - 1;
      var candidate = Position(previous.x, y);
      final candidates = (obstacles
          .where((e) => (e.x == previous.x && e.y > previous.y))
          .toList()
        ..sort((a, b) => a.y.compareTo(b.y)));
      if (candidates.isNotEmpty) {
        candidate = candidates.first;
        y = candidate.y - 1;
      }
    } else {
      y = 0;
      var candidate = Position(previous.x, 0);
      final candidates = (obstacles
          .where((e) => (e.x == previous.x && e.y < previous.y))
          .toList()
        ..sort((a, b) => -1 * a.y.compareTo(b.y)));
      if (candidates.isNotEmpty) {
        candidate = candidates.first;
        y = candidate.y + 1;
      }
    }
    x = previous.x;
  }
  return Position(x, y);
}

List<Position> generateObstacles(Position position, int maxObstaclesNum) {
  final obstaclesNumber = Random().nextInt(maxObstaclesNum);

  return (List.generate(gridNum * gridNum, (index) => index)..shuffle())
      .getRange(0, obstaclesNumber)
      .map(Position.fromInt)
      .toList()
    ..remove(position);
}

Map<String, dynamic> solvePuzzle(Position start, List<Position> obstacles) {
  final queue = Queue<Node>();
  final _seenPositions = <Position>[];
  var node = Node(start);

  queue.add(node);

  while (queue.isNotEmpty) {
    node = queue.removeFirst();
    _seenPositions.add(node.position);
    final nextDirections =
        _decideDirectionsFromPrevious(node.previousDirection);
    for (final nextDirection in nextDirections) {
      final nextPosition =
          movePosition(node.position, nextDirection, obstacles);
      if (!_seenPositions.contains(nextPosition)) {
        queue.add(Node(nextPosition, nextDirection, node));
      }
    }
  }
  var depth = 0;
  var _node = node;
  while (_node.hasParent) {
    depth++;
    _node = _node.parent!;
  }
  return <String, dynamic>{
    'goal_position': node.position,
    'depth': depth,
  };
}

Map<String, dynamic> generatePuzzle(Map<String, int> args) {
  List<Position> obstacles;
  Map<String, dynamic> result;

  final start = Position(args['start_x']!, args['start_y']!);
  final minDepth = args['min_depth']!;

  while (true) {
    obstacles = generateObstacles(start, 3 * minDepth ~/ 4);
    result = solvePuzzle(start, obstacles);
    final depth = result['depth']! as int;
    if (depth > minDepth) {
      break;
    }
  }
  return <String, dynamic>{
    'obstacles': obstacles,
    'goal_position': result['goal_position'],
  };
}

List<Direction> _decideDirectionsFromPrevious(Direction? direction) {
  if (direction == null) {
    return [
      const Direction(Sign.positive, Axis.x),
      const Direction(Sign.positive, Axis.y),
      const Direction(Sign.negative, Axis.x),
      const Direction(Sign.negative, Axis.y),
    ];
  }
  switch (direction.axis) {
    case Axis.x:
      return Sign.values.map((sign) => Direction(sign, Axis.y)).toList();
    case Axis.y:
      return Sign.values.map((sign) => Direction(sign, Axis.x)).toList();
  }
}
