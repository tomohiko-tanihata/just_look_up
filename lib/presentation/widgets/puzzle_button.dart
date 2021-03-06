import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';

class PuzzleButton extends StatelessWidget {
  const PuzzleButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: context.watch<PuzzleResponsiveCubit>().state.size.buttonHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Text(
          text,
          style:
              context.watch<PuzzleResponsiveCubit>().state.textStyle.subheading,
        ),
      ),
    );
  }
}
