import 'package:just_look_up/core/responsive/size/puzzle_size.dart';

class PuzzleMobileSize extends PuzzleSize {
  const PuzzleMobileSize() : super();

  @override
  double get earthDimension => 300;

  @override
  double get meteoDimension => 200;

  @override
  double get titleShadow => 2;

  @override
  double get headerPadding => 8;

  @override
  double get divPadding => 8;

  @override
  double get infoHeight => 56;

  @override
  double get buttonHeight => 32;

  @override
  double get timerDimension => 40;

  @override
  double get tileBorderRadius => 4;

  @override
  double get boardDimension => 292;

  @override
  double get boardPadding => 16;

  @override
  double get scoreButtonWidth => 100;

  @override
  double get scorePaddingWidth => 16;

  @override
  double get confettiSize => 12;
}
