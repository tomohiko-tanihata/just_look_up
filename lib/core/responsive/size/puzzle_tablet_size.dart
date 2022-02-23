import 'package:just_look_up/core/responsive/size/puzzle_size.dart';

class PuzzleTabletSize extends PuzzleSize {
  const PuzzleTabletSize() : super();

  @override
  double get earthDimension => 400;

  @override
  double get meteoDimension => 300;

  @override
  double get titleShadow => 3;

  @override
  double get headerPadding => 12;

  @override
  double get divPadding => 12;

  @override
  double get infoHeight => 84;

  @override
  double get buttonHeight => 48;

  @override
  double get timerDimension => 60;

  @override
  double get tileBorderRadius => 6;

  @override
  double get boardDimension => 432;

  @override
  double get boardPadding => 24;

  @override
  double get scoreButtonWidth => 150;

  @override
  double get scorePaddingWidth => 24;

  @override
  double get confettiSize => 16;
}
