import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_button.dart';

class PuzzleChangeStatusButton extends StatelessWidget {
  const PuzzleChangeStatusButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PuzzleBloc>().state;
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    return Padding(
      padding: EdgeInsets.only(top: size.divPadding),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: state.puzzleStatus == PuzzleStatus.trainingInProgress
            ? PuzzleButton(
                text: 'Start',
                color: PuzzleColors.blue,
                onTap: () => context
                    .read<PuzzleBloc>()
                    .add(const PuzzleTrialInitialized()))
            : state.puzzleStatus == PuzzleStatus.timeTrialInProgress
                ? PuzzleButton(
                    text: 'Give Up',
                    color: PuzzleColors.orange,
                    onTap: () => context
                        .read<PuzzleBloc>()
                        .add(const PuzzleTrainingStarted()),
                  )
                : SizedBox(
                    height: size.buttonHeight,
                  ),
      ),
    );
  }
}
