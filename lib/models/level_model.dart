enum LevelDifficulty { easy, normal, hard }

class LevelModel {
  final int id;
  final int number;
  final List<String> cardImages;
  final LevelDifficulty difficulty;
  final int minutes;
  final int seconds;

  LevelModel(
      {required this.id,
      required this.cardImages,
      required this.minutes,
      required this.seconds,
      required this.difficulty,
      required this.number});
}
