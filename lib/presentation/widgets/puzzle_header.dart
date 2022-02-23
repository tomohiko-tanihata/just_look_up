import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_look_up/core/color.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../bloc/puzzle_bloc.dart';
import 'puzzle_button.dart';
import 'puzzle_info.dart';

class PuzzleHeader extends StatelessWidget {
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.watch<PuzzleResponsiveCubit>().state;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.size.divPadding),
      child: SizedBox(
        height: responsive.size.titleHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SimpleShadow(
              color: PuzzleColors.darkBlue,
              offset: Offset(0, responsive.size.titleShadow),
              child: SvgPicture.asset(
                'assets/images/title.svg',
                height: responsive.size.titleHeight,
              ),
            ),
            SizedBox(width: responsive.size.divPadding),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SAVE EARTH FROM\nA KILLER ASTEROID',
                    style: responsive.textStyle.body,
                  ),
                  const PuzzleInfo(),
                  PuzzleButton(
                    text: 'Redo',
                    color: PuzzleColors.darkBlue,
                    onTap: () =>
                        context.read<PuzzleBloc>().add(const PuzzleRestart()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
