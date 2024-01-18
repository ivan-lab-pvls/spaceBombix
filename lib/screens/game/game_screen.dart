import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space_bombs_app/models/card_model.dart';
import 'package:space_bombs_app/models/level_model.dart';
import 'package:space_bombs_app/repository/levels_repository.dart';
import 'package:space_bombs_app/router/router.dart';
import 'package:space_bombs_app/screens/game/widgets/card_widget.dart';
import 'package:space_bombs_app/theme/colors.dart';
import 'package:space_bombs_app/widgets/text_card_widget.dart';

@RoutePage()
class GameScreen extends StatefulWidget {
  final LevelModel level;

  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Duration duration;

  @override
  void initState() {
    super.initState();
    duration = const Duration();
    generateCards();
    generateImages();
    startGame();
  }

  List<CardModel> cards = [];
  bool isGameOver = false;
  Set<String> images = {};

  void generateCards() {
    generateImages();
    cards = [];
    for (int i = 0; i < 13; i++) {
      final cardValue = i + 1;
      final String image = images.elementAt(i);
      final List<CardModel> newCards = _createCardModels(image, cardValue);
      cards.addAll(newCards);
    }
    cards.add(CardModel(value: 14, image: 'assets/images/game/bomb.png'));
    cards.shuffle(Random());

  }

  void generateImages() {
    images = <String>{};
    for (int j = 0; j < 13; j++) {
      final String image = _getRandomCardImage();
      images.add(image);
      images.add(image);
    }
  }

  void resetGame() {
    generateCards();
    isGameOver = false;
  }

  void startGame() {
    for (int i = 0; i < cards.length; i++) {
      cards[i].state = CardState.visible;
    }
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        for (int i = 0; i < cards.length; i++) {
          cards[i].state = CardState.hidden;
        }
      });
    });
  }

  void onCardPressed(int index) {
    setState(() {
      cards[index].state = CardState.visible;
    });
    final List<int> visibleCardIndexes = _getVisibleCardIndexes();
    if (cards[index].image == 'assets/images/game/bomb.png') {
      Future.delayed(const Duration(seconds: 1), () {
        _showLostDialog();
      });
    }
    if (visibleCardIndexes.length == 2) {
      final CardModel card1 = cards[visibleCardIndexes[0]];
      final CardModel card2 = cards[visibleCardIndexes[1]];
      if (card1.value == card2.value) {
        card1.state = CardState.guessed;
        card2.state = CardState.guessed;
        isGameOver = _isGameOver();
        if (isGameOver) {
          Future.delayed(const Duration(seconds: 1), () {
            _showCompleteLevelDialog();
          });
        }
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            card1.state = CardState.hidden;
            card2.state = CardState.hidden;
          });
        });
      }
    }
  }

  List<CardModel> _createCardModels(String image, int cardValue) {
    return List.generate(
      2,
      (index) => CardModel(
        value: cardValue,
        image: image,
      ),
    );
  }

  String _getRandomCardImage() {
    final Random random = Random();
    String image;
    do {
      image = widget
          .level.cardImages[random.nextInt(widget.level.cardImages.length)];
    } while (images.contains(image));
    return image;
  }

  List<int> _getVisibleCardIndexes() {
    return cards
        .asMap()
        .entries
        .where((entry) => entry.value.state == CardState.visible)
        .map((entry) => entry.key)
        .toList();
  }

  bool _isGameOver() {
    return cards.every((card) => card.state == CardState.guessed);
  }

  int endTime() {
    return DateTime.now().millisecondsSinceEpoch +
        widget.level.minutes * 60 * 1000 +
        widget.level.seconds * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/game/game-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.black,
                                border: Border.all(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(300))),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.blue,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(300))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: Text(
                                      'Level',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    '${widget.level.number}/5',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 15),
                          widget.level.difficulty == LevelDifficulty.easy
                              ? TextCardWidget(
                                  text: 'Easy', color: AppColors.blue)
                              : widget.level.difficulty ==
                                      LevelDifficulty.normal
                                  ? TextCardWidget(
                                      text: 'Normal', color: AppColors.purple)
                                  : TextCardWidget(
                                      text: 'Hard', color: AppColors.red),
                          SizedBox(width: 35),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.black,
                                border: Border.all(color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(300))),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.blue,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(300))),
                                  child: SvgPicture.asset(
                                    'assets/images/elements/timer.svg',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: SizedBox(
                                    width: 90,
                                    child: CountdownTimer(
                                      textStyle: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      endTime: endTime(),
                                      onEnd: () {
                                        _showLostDialog();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router
                              .popAndPush(PauseRoute(level: widget.level));
                        },
                        child: SvgPicture.asset(
                          'assets/images/elements/menu.svg',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: GridView.builder(
                      itemCount: cards.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 9),
                      itemBuilder: (BuildContext context, int index) {
                        return CardWidget(
                          index: index,
                          card: cards[index],
                          onCardPressed: onCardPressed,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCompleteLevelDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            child: Container(
              height: 350,
              width: 335,
              decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.level.difficulty == LevelDifficulty.hard
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                            ],
                          )
                        : Image.asset('assets/images/elements/blue-bomb.png'),
                    Text(
                      'You found all the bombs.',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Level complete',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You’ve passed the ',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.level.difficulty ==
                                          LevelDifficulty.hard
                                      ? 'Hard'
                                      : widget.level.difficulty ==
                                              LevelDifficulty.normal
                                          ? 'Normal'
                                          : 'Easy',
                                  style: TextStyle(
                                    color: widget.level.difficulty ==
                                            LevelDifficulty.hard
                                        ? AppColors.red
                                        : widget.level.difficulty ==
                                                LevelDifficulty.normal
                                            ? AppColors.purple
                                            : AppColors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'level difficulty level.',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.router.popAndPush(HomeRoute());
                          },
                          child: TextCardWidget(
                            text: 'Back to menu',
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        widget.level.id == 5
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  context.router.push(GameRoute(
                                      level: levelsRepository[
                                          widget.level.id + 1]));
                                },
                                child: TextCardWidget(
                                  text: 'The next difficulty',
                                  color: AppColors.blue,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showLostDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            child: Container(
              height: 350,
              width: 335,
              decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.level.difficulty == LevelDifficulty.hard
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                              Image.asset(
                                  'assets/images/elements/blue-bomb.png'),
                            ],
                          )
                        : Image.asset('assets/images/elements/blue-bomb.png'),
                    Text(
                      'You Lose',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.router.popAndPush(HomeRoute());
                          },
                          child: TextCardWidget(
                            text: 'Back to menu',
                            color: AppColors.blue,
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            context.router.push(GameRoute(level: widget.level));
                          },
                          child: TextCardWidget(
                            text: 'Try again',
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
