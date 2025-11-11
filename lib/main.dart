import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle/provider.dart';
import 'package:shuffle/custom_widgets.dart';
import 'package:shuffle/UI.dart';

void main() {

  runApp(ChangeNotifierProvider(
      create: (_) => ShuffleProvider(),
      child: MaterialApp(
        home: ShuffleUI(),
      )
  )
  );
}

class ShuffleUI extends StatefulWidget {
  const ShuffleUI({super.key});

  @override
  State<ShuffleUI> createState() => _ShuffleUIState();
}

class _ShuffleUIState extends State<ShuffleUI> {
  @override
  Widget build(BuildContext context) {
    return UI();
  }
}
