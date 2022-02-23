import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_timer.dart';

class PuzzleInfo extends StatelessWidget {
  const PuzzleInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PuzzleBloc>().state;
    final responsive = context.watch<PuzzleResponsiveCubit>().state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: state.puzzleStatus == PuzzleStatus.timeTrialInProgress
          ? Container(
              height: responsive.size.infoHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: PuzzleColors.white.withOpacity(0.4),
                border: Border.all(width: 0, style: BorderStyle.none),
                borderRadius: BorderRadius.circular(
                  responsive.size.tileBorderRadius,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const PuzzleTimer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Score',
                        style: responsive.textStyle.body,
                      ),
                      Text(state.score.toString(),
                          style: responsive.textStyle.heading),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
