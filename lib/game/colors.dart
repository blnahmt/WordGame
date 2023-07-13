import 'package:flutter/material.dart';

enum TileColors {
  red(Color(0xffff5555)),
  pink(Color(0xffff79c6)),
  purple(Color(0xffff79c6)),
  yellow(Color(0xfff1fa8c)),
  orange(Color(0xffffb86c)),
  green(Color(0xff50fa7b)),
  cyan(Color(0xff8be9fd)),
  background(Color(0xff282a36)),
  onBackground(Color(0xff44475a)),
  text(Color(0xfff8f8f2));

  final Color color;
  const TileColors(this.color);
}
