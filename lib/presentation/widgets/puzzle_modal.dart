import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/presentation/bloc/puzzle_bloc.dart';

import 'puzzle_initial_count_down.dart';
import 'puzzle_trial_result.dart';

class PuzzleModal extends StatelessWidget {
  const PuzzleModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleStatus =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    return AnimatedOpacity(
      opacity: puzzleStatus == PuzzleStatus.timeTrialInitial ||
              puzzleStatus == PuzzleStatus.timeTrialFinished
          ? 1
          : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        width: size.boardDimension,
        height: size.boardDimension,
        decoration: BoxDecoration(
          color: PuzzleColors.white.withOpacity(0.9),
          border: Border.all(width: 0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(
            size.tileBorderRadius,
          ),
        ),
        child: _PuzzleModalContent(
          puzzleStatus: puzzleStatus,
        ),
      ),
    );
  }
}

class _PuzzleModalContent extends StatelessWidget {
  const _PuzzleModalContent({Key? key, required this.puzzleStatus})
      : super(key: key);
  final PuzzleStatus puzzleStatus;
  @override
  Widget build(BuildContext context) {
    if (puzzleStatus == PuzzleStatus.timeTrialInitial) {
      return const PuzzleInitialCountDown();
    } else if (puzzleStatus == PuzzleStatus.timeTrialFinished) {
      return const PuzzleTrialResult();
    }
    return const SizedBox.shrink();
  }
}
