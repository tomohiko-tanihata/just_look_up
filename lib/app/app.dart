import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_look_up/presentation/page/puzzle_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    for (var _counter = 1; _counter < 7; _counter++) {
      precachePicture(
          ExactAssetPicture(
            SvgPicture.svgStringDecoderOutsideViewBoxBuilder,
            'assets/images/explosion_$_counter.svg',
          ),
          null);
    }
    return const MaterialApp(
      home: PuzzlePage(),
    );
  }
}
