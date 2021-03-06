import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive.dart';
import 'package:just_look_up/core/responsive/puzzle_responsive_cubit.dart';
import 'package:just_look_up/model/direction.dart' as dir;

import '../bloc/puzzle_bloc.dart';
import '../widgets/puzzle_background.dart';
import '../widgets/puzzle_board.dart';
import '../widgets/puzzle_change_status_button.dart';
import '../widgets/puzzle_header.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PuzzleBloc()..add(const PuzzleGenerate(isNewGame: true)),
        ),
        BlocProvider(
          create: (_) => PuzzleResponsiveCubit(),
        ),
      ],
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _handleKeyEvent(RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          context.read<PuzzleBloc>().add(
                const PuzzleTileMoved(
                  dir.Direction(dir.Sign.positive, dir.Axis.x),
                ),
              );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          context.read<PuzzleBloc>().add(
                const PuzzleTileMoved(
                  dir.Direction(dir.Sign.negative, dir.Axis.x),
                ),
              );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          context.read<PuzzleBloc>().add(
                const PuzzleTileMoved(
                  dir.Direction(dir.Sign.negative, dir.Axis.y),
                ),
              );
        } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          context.read<PuzzleBloc>().add(
                const PuzzleTileMoved(
                  dir.Direction(dir.Sign.positive, dir.Axis.y),
                ),
              );
        }
      }
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: context.watch<PuzzleBloc>().state.isInputActivated
          ? _handleKeyEvent
          : null,
      child: Scaffold(
        body: Stack(
          children: const [
            PuzzleBackground(),
            _Puzzle(),
          ],
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        context.read<PuzzleResponsiveCubit>().init(context);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Flex(
                mainAxisAlignment: context.watch<PuzzleResponsiveCubit>().state
                        is PuzzleDesktopResponsive
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                direction: context.watch<PuzzleResponsiveCubit>().state
                        is PuzzleDesktopResponsive
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizedBox(
                    width: context
                        .watch<PuzzleResponsiveCubit>()
                        .state
                        .size
                        .boardDimension,
                    child: const PuzzleHeader(),
                  ),
                  SizedBox(
                    width: context
                        .watch<PuzzleResponsiveCubit>()
                        .state
                        .size
                        .boardDimension,
                    child: Column(
                      children: const [
                        PuzzleBoard(),
                        PuzzleChangeStatusButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
