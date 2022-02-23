import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_explosion.dart';
import 'puzzle_gesture_detector.dart';
import 'puzzle_grid_board.dart';
import 'puzzle_modal.dart';
import 'puzzle_obstacles.dart';

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleGestureDetector(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: const [
            PuzzleGridBoard(),
            _PuzzleGoal(),
            _PuzzleRocket(),
            PuzzleObstacles(),
            PuzzleModal(),
            _PuzzlePopUp(),
            PuzzleExplosion()
          ],
        ),
      ),
    );
  }
}

class _PuzzleRocket extends StatelessWidget {
  const _PuzzleRocket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPosition =
        context.select((PuzzleBloc bloc) => bloc.state.currentPosition);
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      left: currentPosition.x * size.tileDistance + size.boardPadding,
      top: currentPosition.y * size.tileDistance + size.boardPadding,
      child: SvgPicture.asset(
        'assets/images/rocket.svg',
        width: size.tileDimension,
        height: size.tileDimension,
      ),
    );
  }
}

class _PuzzleGoal extends StatelessWidget {
  const _PuzzleGoal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleStatus =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);
    final goalPosition =
        context.select((PuzzleBloc bloc) => bloc.state.goalPosition);
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    return puzzleStatus == PuzzleStatus.timeTrialInitial
        ? const SizedBox.shrink()
        : AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            left: goalPosition.x * size.tileDistance + size.boardPadding,
            top: goalPosition.y * size.tileDistance + size.boardPadding,
            child: Image(
              width: size.tileDimension,
              height: size.tileDimension,
              image: const AssetImage('assets/images/commet.png'),
            ),
          );
  }
}

class _PuzzlePopUp extends StatelessWidget {
  const _PuzzlePopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleStatus =
        context.select((PuzzleBloc bloc) => bloc.state.puzzleStatus);

    if (puzzleStatus == PuzzleStatus.timeTrialInProgress) {
      return const _PuzzleStart();
    }
    return const SizedBox.shrink();
  }
}

class _PuzzleStart extends StatefulWidget {
  const _PuzzleStart({Key? key}) : super(key: key);

  @override
  __PuzzleStartState createState() => __PuzzleStartState();
}

class __PuzzleStartState extends State<_PuzzleStart> {
  double _opacity = 1;
  @override
  void initState() {
    Future<void>.delayed(
        const Duration(seconds: 1),
        () => setState(
              () => _opacity = 0,
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: Text('Start!',
            style: context
                .watch<PuzzleResponsiveCubit>()
                .state
                .textStyle
                .masthead
                .copyWith(color: PuzzleColors.orange)));
  }
}
