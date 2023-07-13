import 'package:game/hive/score_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Score> getScores() => Hive.box<Score>('scores');
}
