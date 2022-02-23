import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/responsive/puzzle_responsive_cubit.dart';

class PuzzleResultConfetti extends StatefulWidget {
  const PuzzleResultConfetti({Key? key}) : super(key: key);

  @override
  _PuzzleResultConfettiState createState() => _PuzzleResultConfettiState();
}

class _PuzzleResultConfettiState extends State<PuzzleResultConfetti> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(microseconds: 300));
    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (var step = 0.0; step < fullAngle; step += degreesPerStep) {
      path
        ..lineTo(halfWidth + externalRadius * cos(step),
            halfWidth + externalRadius * sin(step))
        ..lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
            halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: _controllerCenter,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.1,
        emissionFrequency: 0.01,
        numberOfParticles: 100,
        gravity: 0.01,
        minimumSize: Size.square(
            context.watch<PuzzleResponsiveCubit>().state.size.confettiSize *
                0.8),
        maximumSize: Size.square(
            context.watch<PuzzleResponsiveCubit>().state.size.confettiSize),
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
        createParticlePath: drawStar,
      ),
    );
  }
}
