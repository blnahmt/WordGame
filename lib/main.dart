import 'package:flutter/material.dart';
import 'package:game/game/colors.dart';
import 'package:game/game/gamescreen.dart';
import 'package:game/hive/boxes.dart';
import 'package:game/hive/score_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ScoreAdapter());
  await Hive.openBox<Score>('scores');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.dark(),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TileColors.background.color,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Transform.rotate(
                                  angle: -0.2,
                                  child: Image.asset(
                                    "assets/logo.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: 0.2,
                                  child: Text(
                                    "WORD\nGAME",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: TileColors.text.color,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 8,
                                          height: 1.3,
                                        ),
                                  ),
                                )
                              ]),
                          const SizedBox(
                            height: 120,
                          ),
                        ],
                      ),
                      const PlayButton(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return buildHighScores(context);
                            },
                          );
                        },
                        child: const ScoresButton(),
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildHighScores(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
                color: TileColors.onBackground.color,
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.only(top: 32, right: 12, left: 12),
              child: ValueListenableBuilder<Box<Score>>(
                valueListenable: Boxes.getScores().listenable(),
                builder: (context, value, child) {
                  final scores = value.values.toList().cast<Score>();
                  scores.sort((a, b) => b.score.compareTo(a.score));
                  return Material(
                    color: TileColors.onBackground.color,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 32),
                      itemCount: scores.length,
                      itemBuilder: (context, index) {
                        Score score = scores[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: index % 2 == 0
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
                    ),
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
          Positioned(
              bottom: 42,
              right: 0,
              left: 0,
              child: Center(
                  child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        color: TileColors.red.color,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "CLOSE",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: TileColors.text.color,
                              fontWeight: FontWeight.bold),
                    )),
              ))),
        ],
      ),
    );
  }
}

class ScoresButton extends StatelessWidget {
  const ScoresButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: TileColors.background.color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(width: 2.0, color: TileColors.yellow.color),
        ),
        child: Row(
          children: [
            Icon(
              Icons.star_border_purple500_rounded,
              color: TileColors.text.color,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              "HIGH SCORES",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: TileColors.text.color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return const GameWindow();
          },
        ));
      },
      child: FittedBox(
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: TileColors.background.color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 2.0, color: TileColors.cyan.color),
          ),
          child: Row(
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: TileColors.text.color,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "PLAY",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: TileColors.text.color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
