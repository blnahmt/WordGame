import 'package:hive/hive.dart';

part 'score_model.g.dart';

@HiveType(typeId: 0)
class Score extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late int score;
}
