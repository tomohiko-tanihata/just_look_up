import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_button.dart';
import 'puzzle_result_confetti.dart';

class PuzzleTrialResult extends StatelessWidget {
  const PuzzleTrialResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<PuzzleResponsiveCubit>().state;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const PuzzleResultConfetti(),
            Column(
              children: [
                Text('Score',
                    style: responsive.textStyle.title
                        .copyWith(color: PuzzleColors.darkBlue)),
                Text(context.read<PuzzleBloc>().state.score.toString(),
                    style: responsive.textStyle.masthead
                        .copyWith(color: PuzzleColors.darkBlue)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: responsive.size.scoreButtonWidth,
                  child: PuzzleButton(
                    text: 'Back',
                    color: PuzzleColors.orange,
                    onTap: () => context
                        .read<PuzzleBloc>()
                        .add(const PuzzleTrainingStarted()),
                  ),
                ),
                SizedBox(
                  width: responsive.size.scorePaddingWidth,
                ),
                SizedBox(
                  width: responsive.size.scoreButtonWidth,
                  child: PuzzleButton(
                    text: 'Retry',
                    color: PuzzleColors.blue,
                    onTap: () => context
                        .read<PuzzleBloc>()
                        .add(const PuzzleTrialInitialized()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
