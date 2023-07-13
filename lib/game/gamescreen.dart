import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/game/colors.dart';
import 'package:game/game/gamearea/game.dart';

class GameWindow extends StatefulWidget {
  const GameWindow({super.key});

  @override
  State<GameWindow> createState() => _GameWindowState();
}

class _GameWindowState extends State<GameWindow> {
  bool isLoading = true;
  late final String csvData;
  late final List<String> csvTable;

  @override
  void initState() {
    super.initState();
    loadcsv();
  }

  loadcsv() async {
    csvData = await rootBundle.loadString('assets/kelime.csv');
    String data = csvData.toString();

    csvTable = data.split("\n");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TileColors.onBackground.color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Game(kelimeler: csvTable),
          ))
        ],
      ),
    );
  }
}
