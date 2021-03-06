import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({Key? key, required this.color}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.read<PuzzleResponsiveCubit>().state.size.tileDimension,
      width: context.read<PuzzleResponsiveCubit>().state.size.tileDimension,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(style: BorderStyle.none),
        borderRadius: BorderRadius.circular(
          context.read<PuzzleResponsiveCubit>().state.size.tileBorderRadius,
        ),
      ),
    );
  }
}
