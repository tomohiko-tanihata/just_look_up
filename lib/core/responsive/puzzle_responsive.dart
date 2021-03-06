import 'package:just_look_up/core/responsive/typography/typography.dart';

import 'size/size.dart';

abstract class PuzzleResponsive {
  const PuzzleResponsive(this.size, this.textStyle);
  final PuzzleSize size;
  final PuzzleTextStyle textStyle;
}

class PuzzleMobileResponsive extends PuzzleResponsive {
  const PuzzleMobileResponsive()
      : super(const PuzzleMobileSize(), const PuzzleMobileTextStyle());
}

class PuzzleTabletResponsive extends PuzzleResponsive {
  const PuzzleTabletResponsive()
      : super(const PuzzleTabletSize(), const PuzzleTabletTextStyle());
}

class PuzzleDesktopResponsive extends PuzzleResponsive {
  const PuzzleDesktopResponsive()
      : super(const PuzzleDesktopSize(), const PuzzleDesktopTextStyle());
}
