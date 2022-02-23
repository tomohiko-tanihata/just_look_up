import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';

import '../../core/responsive/puzzle_responsive_cubit.dart';
import '../bloc/puzzle_bloc.dart';

class PuzzleTimer extends StatefulWidget {
  const PuzzleTimer({Key? key}) : super(key: key);

  @override
  _PuzzleTimerState createState() => _PuzzleTimerState();
}

class _PuzzleTimerState extends State<PuzzleTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    controller.forward().whenComplete(
        () => context.read<PuzzleBloc>().add(const PuzzleTrialFinished()));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, w) {
          return Container(
            width: context
                .watch<PuzzleResponsiveCubit>()
                .state
                .size
                .timerDimension,
            height: context
                .watch<PuzzleResponsiveCubit>()
                .state
                .size
                .timerDimension,
            decoration: BoxDecoration(
                color: PuzzleColors.white, shape: BoxShape.circle),
            child: CustomPaint(
              painter: CustomTimerPainter(
                animation: controller,
                backgroundColor: PuzzleColors.darkBlue.withOpacity(0.2),
                color: PuzzleColors.darkBlue,
              ),
              child: Center(
                child: Text(
                  (60 * (1 - controller.value)).toInt().toString(),
                  style: context
                      .watch<PuzzleResponsiveCubit>()
                      .state
                      .textStyle
                      .body
                      .copyWith(color: PuzzleColors.darkBlue, fontFeatures: [
                    const FontFeature.tabularFigures(),
                  ]),
                ),
              ),
            ),
          );
        });
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = size.width / 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero),
        size.width / 2.0 - paint.strokeWidth / 2, paint);
    paint.color = color;
    final progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(
        Offset.fromDirection(pi / 4, paint.strokeWidth / sqrt(2)) &
            Size(size.height - paint.strokeWidth,
                size.width - paint.strokeWidth),
        pi * 1.5,
        progress,
        false,
        paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
