import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/model/position.dart';

import '../bloc/puzzle_bloc.dart';

class PuzzleExplosion extends StatefulWidget {
  const PuzzleExplosion({Key? key}) : super(key: key);

  @override
  _PuzzleExplosionState createState() => _PuzzleExplosionState();
}

class _PuzzleExplosionState extends State<PuzzleExplosion>
    with SingleTickerProviderStateMixin {
  Position? _explosionPosition;

  AnimationController? animationController;

  late int _counter;
  late Timer _timer;

  void explode(Position position) {
    setState(() {
      _counter = 1;
      _explosionPosition = position;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_counter < 5) {
        setState(() => _counter++);
      } else {
        _timer.cancel();
        setState(() {
          _explosionPosition = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    return BlocListener<PuzzleBloc, PuzzleState>(
      listenWhen: (previous, current) => current.score == previous.score + 1,
      listener: (context, state) {
        explode(state.goalPosition);
      },
      child: _explosionPosition == null
          ? const SizedBox.shrink()
          : Positioned(
              left: _explosionPosition!.x * size.tileDistance +
                  size.boardPadding -
                  size.tileDimension / 2,
              top: _explosionPosition!.y * size.tileDistance +
                  size.boardPadding -
                  size.tileDimension / 2,
              child: SvgPicture.asset(
                'assets/images/explosion_$_counter.svg',
                allowDrawingOutsideViewBox: true,
                key: ValueKey<String>('$_counter'),
                width: size.tileDimension * 2,
                height: size.tileDimension * 2,
              ),
            ),
    );
  }
}
