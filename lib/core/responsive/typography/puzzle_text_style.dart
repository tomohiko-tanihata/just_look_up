import 'package:flutter/widgets.dart';
import 'package:just_look_up/core/color.dart';

/// Defines text styles for the puzzle UI.
abstract class PuzzleTextStyle {
  const PuzzleTextStyle();
  double get mastheadSize;
  double get titleSize;
  double get headingSize;
  double get subheadingSize;
  double get bodySize;

  TextStyle get masthead {
    return baseTextStyle.copyWith(
      fontSize: mastheadSize,
    );
  }

  TextStyle get title {
    return baseTextStyle.copyWith(
      fontSize: titleSize,
    );
  }

  TextStyle get heading {
    return baseTextStyle.copyWith(
      fontSize: headingSize,
    );
  }

  TextStyle get subheading {
    return baseTextStyle.copyWith(
      fontSize: subheadingSize,
    );
  }

  TextStyle get body {
    return baseTextStyle.copyWith(
      fontSize: bodySize,
    );
  }

  static final baseTextStyle = TextStyle(
    fontFamily: 'Nunito Sans',
    color: PuzzleColors.white,
    fontWeight: FontWeight.w900,
  );
}
