import 'package:equatable/equatable.dart';
import 'package:just_look_up/core/constants.dart';

class Position extends Equatable {
  const Position(this.x, this.y);

  factory Position.fromInt(int i) {
    final x = i % gridNum;
    final y = i ~/ gridNum;
    return Position(x, y);
  }

  final int x;
  final int y;

  @override
  List<Object> get props => [x, y];
}
