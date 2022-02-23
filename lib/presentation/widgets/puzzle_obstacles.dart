import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/constants.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/model/position.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_tile.dart';

class PuzzleObstacles extends StatelessWidget {
  const PuzzleObstacles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obstalces = context.select((PuzzleBloc bloc) => bloc.state.obstacles);
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    final tiles = List.generate(gridNum * gridNum, (i) => i)
        .map(
          (i) => Center(
            child: AnimatedOpacity(
              opacity: obstalces.contains(Position.fromInt(i)) ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutBack,
                scale: obstalces.contains(Position.fromInt(i)) ? 1 : 0.5,
                child: PuzzleTile(
                  color: PuzzleColors.darkBlue,
                ),
              ),
            ),
          ),
        )
        .toList();

    return SizedBox(
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
    );
  }
}
