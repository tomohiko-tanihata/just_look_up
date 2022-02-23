import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/presentation/bloc/puzzle_bloc.dart';

class PuzzleInitialCountDown extends StatefulWidget {
  const PuzzleInitialCountDown({Key? key}) : super(key: key);
  @override
  _PuzzleInitialCountDownState createState() => _PuzzleInitialCountDownState();
}

class _PuzzleInitialCountDownState extends State<PuzzleInitialCountDown>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  int _counter = 3;
  late Timer _timer;
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
        context.read<PuzzleBloc>().add(const PuzzleTrialStarted());
      }
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animationController!.repeat();
    _startTimer();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController!,
      child: Text(_counter.toString(),
          style: context
              .watch<PuzzleResponsiveCubit>()
              .state
              .textStyle
              .masthead
              .copyWith(color: PuzzleColors.darkBlue)),
    );
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }
}
