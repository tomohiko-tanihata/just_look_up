import '../../constants.dart';

abstract class PuzzleSize {
  const PuzzleSize();

  double get earthDimension;

  double get meteoDimension;

  double get titleShadow;

  double get headerPadding;

  double get divPadding;

  double get infoHeight;

  double get buttonHeight;

  double get timerDimension;

  double get tileBorderRadius;

  double get boardDimension;

  double get boardPadding;

  double get scoreButtonWidth;

  double get scorePaddingWidth;

  double get confettiSize;

  double get titleHeight => boardDimension / 2;

  double get tileDimension =>
      (boardDimension - 2 * boardPadding) / (9 * gridNum - 1) * 8;

  double get boardSpacing =>
      (boardDimension - 2 * boardPadding) / (9 * gridNum - 1);

  double get tileDistance => tileDimension + boardSpacing;
}
