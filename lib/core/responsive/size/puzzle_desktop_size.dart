import 'package:just_look_up/core/responsive/size/puzzle_size.dart';

class PuzzleDesktopSize extends PuzzleSize {
  const PuzzleDesktopSize() : super();

  @override
  double get earthDimension => 600;

  @override
  double get meteoDimension => 400;

  @override
  double get titleShadow => 4;

  @override
  double get headerPadding => 16;

  @override
  double get divPadding => 16;

  @override
  double get infoHeight => 112;

  @override
  double get buttonHeight => 64;

  @override
  double get timerDimension => 80;

  @override
  double get tileBorderRadius => 8;

  @override
  double get boardDimension => 584;

  @override
  double get boardPadding => 32;

  @override
  double get scoreButtonWidth => 200;

  @override
  double get scorePaddingWidth => 32;

  @override
  double get confettiSize => 16;
}
