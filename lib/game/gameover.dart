import 'package:flutter/material.dart';
import 'package:game/game/colors.dart';
import 'package:game/game/gamescreen.dart';
import 'package:game/hive/boxes.dart';
import 'package:game/hive/score_model.dart';
import 'package:game/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

class GameOver extends StatefulWidget {
  const GameOver({super.key, required this.score});
  final int score;

  @override
  State<GameOver> createState() => _GameOverState();
}

class _GameOverState extends State<GameOver> {
  String id = "";

  @override
  void dispose() {
    Hive.box('scores').close();

    super.dispose();
  }

  @override
  void initState() {
    //
    super.initState();
    final score = Score()
      ..id = DateTime.now().toString()
      ..score = widget.score;

    final box = Boxes.getScores();
    box.add(score);
    id = score.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TileColors.background.color,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Text("GAME OVER",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: TileColors.text.color, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 42,
            ),
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                        color: TileColors.onBackground.color,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Center(
                      child: Text(
                        "${widget.score}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: TileColors.text.color,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 6,
                      right: 0,
                      left: 0,
                      child: Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  color: TileColors.text.color,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "SCORE",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        color: TileColors.background.color,
                                        fontWeight: FontWeight.bold),
                              )))),
                ],
              ),
            ),
            Expanded(
                child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                      color: TileColors.onBackground.color,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 32, right: 12, left: 12),
                    child: ValueListenableBuilder<Box<Score>>(
                      valueListenable: Boxes.getScores().listenable(),
                      builder: (context, value, child) {
                        final scores = value.values.toList().cast<Score>();
                        scores.sort((a, b) => b.score.compareTo(a.score));
                        return ListView.builder(
                          itemCount: scores.length,
                          itemBuilder: (context, index) {
                            Score score = scores[index];
                            return Container(
                              decoration: BoxDecoration(
                                  color: score.id == id
                                      ? TileColors.orange.color
                                      : index % 2 == 0
                                          ? TileColors.background.color
                                          : TileColors.onBackground.color,
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                title: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Text(
                                        "${index + 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                color: TileColors.text.color,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: VerticalDivider(
                                          thickness: 2.0,
                                          width: 32.0,
                                          color: TileColors.text.color,
                                        ),
                                      ),
                                      Text(
                                        score.score.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                color: TileColors.text.color,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                    top: 6,
                    right: 0,
                    left: 0,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                color: TileColors.text.color,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "HIGH SCORES",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      color: TileColors.background.color,
                                      fontWeight: FontWeight.bold),
                            )))),
              ],
            )),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const GameWindow();
                        },
                      ));
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: TileColors.background.color,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 2.0, color: TileColors.cyan.color),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.replay_outlined,
                            color: TileColors.text.color,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "PLAY AGAIN",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: TileColors.text.color,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const MainMenu();
                        },
                      ));
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: TileColors.background.color,
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(width: 2.0, color: TileColors.red.color),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.home_rounded,
                            color: TileColors.text.color,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "MAIN MENU",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: TileColors.text.color,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
