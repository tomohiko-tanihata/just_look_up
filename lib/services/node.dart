import 'package:just_look_up/model/direction.dart';
import 'package:just_look_up/model/position.dart';

class Node {
  Node(
    this.position, [
    this.previousDirection,
    this.parent,
  ]);

  final Position position;
  final Direction? previousDirection;
  final Node? parent;

  bool get hasParent => parent != null;
}
