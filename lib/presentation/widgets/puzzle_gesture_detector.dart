import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/model/direction.dart' as dir;

import '../bloc/puzzle_bloc.dart';

class PuzzleGestureDetector extends StatelessWidget {
  const PuzzleGestureDetector({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var _initialOffset = Offset.zero;
    var _latestOffset = Offset.zero;
    const _kMinPanDistance = 16.0;

    void _onPanDown(DragDownDetails details) {
      _initialOffset = details.localPosition;
    }

    void _onPanUpdate(DragUpdateDetails details) {
      _latestOffset = details.localPosition;
    }

    void _onPanEnd(DragEndDetails details) {
      final d = _latestOffset - _initialOffset;
      dir.Sign sign;
      dir.Axis axis;
      double value;
      if (d.dx.abs() > d.dy.abs()) {
        axis = dir.Axis.x;
        value = d.dx;
      } else {
        axis = dir.Axis.y;
        value = d.dy;
      }
      if (value > 0) {
        sign = dir.Sign.positive;
      } else {
        sign = dir.Sign.negative;
      }
      if (value.abs() > _kMinPanDistance) {
        context.read<PuzzleBloc>().add(
              PuzzleTileMoved(
                dir.Direction(sign, axis),
              ),
            );
      }
    }

    return GestureDetector(
      onPanDown: context.watch<PuzzleBloc>().state.isInputActivated
          ? _onPanDown
          : null,
      onPanUpdate: context.watch<PuzzleBloc>().state.isInputActivated
          ? _onPanUpdate
          : null,
      onPanEnd:
          context.watch<PuzzleBloc>().state.isInputActivated ? _onPanEnd : null,
      child: child,
    );
  }
}
