import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game/game/colors.dart';
import 'package:game/game/gamearea/topbar.dart';
import 'package:game/game/gameover.dart';
import 'package:game/game/harfler.dart';

import '../block.dart';

const blockx = 8;
const blocky = 10;
const blockGapsWidth = 2.0;
const gameareaBorderWidth = 6.0;

class Game extends StatefulWidget {
  const Game({super.key, required this.kelimeler});
  final List<String> kelimeler;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  double? blockWidth;

  List<int> indexes = [];

  final GlobalKey _keyGameArea = GlobalKey();
  bool isStarted = false;

  bool isGameOver = false;

  List<Block> blocks = [];
  List<Block> selectedBlocks = [];
  late Timer mainTimer;

  int skor = 0;
  int sure = 5;
  int wrong = 0;

  @override
  void initState() {
    super.initState();
    for (var element in Harf.values) {
      int index = Harf.values.indexOf(element);
      for (var i = 0; i < element.rate; i++) {
        indexes.add(index);
      }
    }

    Future.delayed(const Duration(seconds: 1)).then((value) => onStart());
  }

  onStart() {
    RenderBox? renderBox =
        _keyGameArea.currentContext?.findRenderObject() as RenderBox;
    blockWidth = (renderBox.size.width - gameareaBorderWidth) / blockx;

    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 8; j++) {
        Random rand = Random();
        int randomInt = rand.nextInt(indexes.length);
        Harf harf = Harf.values[indexes[randomInt]];
        int colorIndex = Random().nextInt(TileColors.values.length - 3);
        Block newBlock = Block(j, -2 * i, harf);
        newBlock.color = TileColors.values.elementAt(colorIndex).color;
        newBlock.timer =
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
          onPlay(timer, newBlock);
        });
        blocks.add(newBlock);
      }
    }
    Future.delayed(const Duration(seconds: 1)).then((value) =>
        mainTimer = Timer.periodic(Duration(seconds: sure), addNewBlock));
  }

  drawLine() {
    for (var j = 0; j < 8; j++) {
      Random rand = Random();
      int randomInt = rand.nextInt(indexes.length);
      Harf harf = Harf.values[indexes[randomInt]];
      int colorIndex = rand.nextInt(TileColors.values.length - 3);
      Block newBlock = Block(j, -1, harf);
      newBlock.color = TileColors.values.elementAt(colorIndex).color;
      newBlock.timer =
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
        onPlay(timer, newBlock);
      });
      blocks.add(newBlock);
    }
  }

  addNewBlock(Timer timer) {
    Random rand = Random();
    int randomInt = rand.nextInt(indexes.length);
    Harf harf = Harf.values[indexes[randomInt]];
    int colorIndex = rand.nextInt(TileColors.values.length - 3);
    int x = rand.nextInt(blockx);
    Block newBlock = Block(x, 0, harf);
    newBlock.color = TileColors.values.elementAt(colorIndex).color;
    newBlock.timer =
        Timer.periodic(const Duration(milliseconds: 100), (timer2) {
      onPlay(timer2, newBlock);
    });
    blocks.add(newBlock);
  }

  onPlay(Timer timer, Block block) {
    if (!checkAtBottom(block)) {
      if (!checkAboveBlock(block)) {
        block.move();
      } else {
        block.collision = Collision.landedBlock;
      }
    } else {
      block.collision = Collision.landed;
    }
    setState(() {});
    bool isOver = false;

    for (var i = 0; i < 8; i++) {
      var list = blocks.where((element) => element.x == i);
      if (list.length >= 10) {
        isOver = true;
      }
    }

    if (isOver) {
      mainTimer.cancel();
      timer.cancel();
      for (var element in blocks) {
        element.timer?.cancel();
      }

      if (!isGameOver) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GameOver(score: skor),
        ));
        isGameOver = true;
      }
    }
  }

  AnimatedPositioned getPositionedSquareBlock(Block block) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 0),
      left: block.x! * blockWidth!,
      top: block.y! * blockWidth!,
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (!block.isSelected) {
              block.isSelected = true;
              selectedBlocks.add(block);
            } else {
              block.isSelected = false;
              selectedBlocks.remove(block);
            }
          });
        },
        child: Container(
          width: blockWidth!,
          height: blockWidth!,
          decoration: BoxDecoration(
              color: block.isSelected
                  ? TileColors.onBackground.color
                  : block.color,
              shape: BoxShape.rectangle,
              border: Border.all(
                  width: 1.0,
                  color: block.isSelected
                      ? TileColors.text.color
                      : TileColors.onBackground.color,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              block.harf?.harf ?? "",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: block.isSelected
                      ? TileColors.text.color
                      : TileColors.onBackground.color,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget? drawBlocks() {
    //if (block == null) return null;

    List<AnimatedPositioned> allBlocks = [];

    // Positioned blockDen = getPositionedSquareBlock(block!);
    //allBlocks.add(blockDen);

    for (var e in blocks) {
      allBlocks.add(getPositionedSquareBlock(e));
    }
    return Stack(
      children: allBlocks,
    );
  }

  bool checkAtBottom(Block block) {
    return (block.y ?? 0) + 1 == blocky;
  }

  bool checkAboveBlock(Block block) {
    for (Block item in blocks) {
      var x = block.x ?? 0;
      var y = block.y ?? 0;
      if (x == item.x && y + 1 == item.y) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 100) {
          checkWord();
        } else if (details.velocity.pixelsPerSecond.dx < -100) {
          deleteWord();
        }
      },
      child: Column(
        children: [
          TopBar(skor: skor, wrong: wrong),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            child: AspectRatio(
              aspectRatio: blockx / blocky,
              child: Container(
                key: _keyGameArea,
                decoration: BoxDecoration(
                    color: TileColors.background.color,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                        width: gameareaBorderWidth / 2,
                        color: TileColors.text.color)),
                child: drawBlocks(),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SelectedWords(
              selectedHarfler: selectedBlocks, blockWidth: blockWidth),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: deleteWord,
                    icon: const Icon(Icons.backspace_rounded)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: checkWord,
                    icon: const Icon(Icons.check_rounded)),
              )
            ],
          ),
        ],
      ),
    );
  }

  void deleteWord() {
    selectedBlocks.last.isSelected = false;
    selectedBlocks.removeLast();

    setState(() {});
  }

  void checkWord() {
    var word = "";
    for (var element in selectedBlocks) {
      word += element.harf?.harf ?? "";
    }
    word = word.toUpperCase();

    var list =
        widget.kelimeler.where((element) => element.toUpperCase() == word);

    var len = list.length;
    if (len != 0) {
      for (var element in blocks) {
        element.collision == Collision.none;
      }
      for (var element in selectedBlocks) {
        blocks.remove(element);
        skor += element.harf!.point;
      }

      selectedBlocks.clear();

      if (skor >= 400 && sure >= 2) {
        sure = 1;
        mainTimer.cancel();
        mainTimer = Timer.periodic(Duration(seconds: sure), addNewBlock);
      } else if (skor >= 300 && sure >= 3) {
        sure = 2;
        mainTimer.cancel();
        mainTimer = Timer.periodic(Duration(seconds: sure), addNewBlock);
      } else if (skor >= 200 && sure >= 4) {
        sure = 3;
        mainTimer.cancel();
        mainTimer = Timer.periodic(Duration(seconds: sure), addNewBlock);
      } else if (skor >= 100 && sure >= 5) {
        sure = 4;
        mainTimer.cancel();
        mainTimer = Timer.periodic(Duration(seconds: sure), addNewBlock);
      }
    } else {
      if (wrong < 2) {
        wrong++;
      } else {
        wrong = 0;
        drawLine();
      }
    }
    setState(() {});
  }
}

class SelectedWords extends StatelessWidget {
  const SelectedWords({
    super.key,
    required this.selectedHarfler,
    required this.blockWidth,
  });

  final List<Block> selectedHarfler;
  final double? blockWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: TileColors.background.color,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(2.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            String text = "";
            for (var element in selectedHarfler) {
              text += element.harf!.harf;
            }
            return Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: TileColors.text.color, letterSpacing: 4),
            );
          }),
        ),
      ]),
    );
  }
}
