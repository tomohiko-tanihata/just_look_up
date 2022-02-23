import 'package:equatable/equatable.dart';

enum Sign { positive, negative }

enum Axis { x, y }

class Direction extends Equatable {
  const Direction(this.sign, this.axis);

  final Sign sign;
  final Axis axis;

  @override
  List<Object> get props => [sign, axis];
}
