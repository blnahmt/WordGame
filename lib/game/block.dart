import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/game/harfler.dart';

class Block {
  int? x;
  int? y;
  bool isSelected = false;
  Harf? harf;
  Collision? collision;
  Color? color;
  Timer? timer;

  Block(
    int this.x,
    int this.y,
    Harf this.harf, [
    this.timer,
    Color this.color = Colors.transparent,
    Collision this.collision = Collision.none,
  ]);

  void move() {
    y = y! + 1;
  }
}

enum Collision { landed, landedBlock, none }
