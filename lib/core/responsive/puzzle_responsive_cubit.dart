import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'breakpoints.dart';
import 'puzzle_responsive.dart';

class PuzzleResponsiveCubit extends Cubit<PuzzleResponsive> {
  PuzzleResponsiveCubit() : super(const PuzzleMobileResponsive());

  void init(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= PuzzleBreakpoints.mobile) {
      emit(const PuzzleMobileResponsive());
    } else if (screenWidth <= PuzzleBreakpoints.tablet) {
      emit(const PuzzleTabletResponsive());
    } else {
      emit(const PuzzleDesktopResponsive());
    }
  }
}
