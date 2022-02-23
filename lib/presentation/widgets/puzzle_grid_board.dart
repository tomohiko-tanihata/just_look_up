import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/constants.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/model/position.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_tile.dart';

extension PositionExt on Position {
  bool isSame(int i) {
    return x + y * gridNum == i;
  }
}

class PuzzleGridBoard extends StatelessWidget {
  const PuzzleGridBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPosition =
        context.select((PuzzleBloc bloc) => bloc.state.currentPosition);
    final goalPosition =
        context.select((PuzzleBloc bloc) => bloc.state.goalPosition);
    final tiles = List.generate(gridNum * gridNum, (i) => i).map(
      (i) {
        return AnimatedOpacity(
          opacity: currentPosition.isSame(i) || goalPosition.isSame(i) ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: PuzzleTile(
            color: PuzzleColors.white,
          ),
        );
      },
    ).toList();
    final size = context.watch<PuzzleResponsiveCubit>().state.size;

    return Container(
      decoration: BoxDecoration(
        color: PuzzleColors.white.withOpacity(0.4),
        border: Border.all(width: 0, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(
          size.tileBorderRadius,
        ),
      ),
      child: SizedBox(
        height: size.boardDimension,
        width: size.boardDimension,
        child: GridView.count(
          padding: EdgeInsets.all(size.boardPadding),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: gridNum,
          mainAxisSpacing: size.boardSpacing,
          crossAxisSpacing: size.boardSpacing,
          children: tiles,
        ),
      ),
    );
  }
}
