import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/core/responsive/size/puzzle_desktop_size.dart';

class PuzzleBackground extends StatefulWidget {
  const PuzzleBackground({Key? key}) : super(key: key);

  @override
  _PuzzleBackgroundState createState() => _PuzzleBackgroundState();
}

class _PuzzleBackgroundState extends State<PuzzleBackground> {
  @override
  Widget build(BuildContext context) {
    final size = context.watch<PuzzleResponsiveCubit>().state.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceWidth = (screenWidth - size.boardDimension) / 2;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PuzzleColors.blue,
                PuzzleColors.darkBlue,
              ],
            ),
          ),
          child: const Image(
            image: AssetImage('assets/images/stars.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        Positioned(
          left: -size.earthDimension / 3,
          bottom: screenHeight / 4 - size.boardDimension / 1.2,
          child: Opacity(
            opacity: 0.7,
            child: Image(
              width: size.earthDimension,
              height: size.earthDimension,
              image: const AssetImage('assets/images/earth.png'),
            ),
          ),
        ),
        Positioned(
          right: size is PuzzleDesktopSize ? screenWidth / 2 : spaceWidth / 4,
          top: screenHeight / 4 - size.boardDimension / 2,
          child: Opacity(
            opacity: 0.7,
            child: Image(
              width: size.meteoDimension,
              height: size.meteoDimension,
              image: const AssetImage('assets/images/meteo.png'),
            ),
          ),
        ),
      ],
    );
  }
}
