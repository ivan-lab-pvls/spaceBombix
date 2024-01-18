import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space_bombs_app/models/level_model.dart';
import 'package:space_bombs_app/repository/levels_repository.dart';
import 'package:space_bombs_app/router/router.dart';
import 'package:space_bombs_app/theme/colors.dart';
import 'package:space_bombs_app/widgets/action_button_widget.dart';

@RoutePage()
class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/elements/levels-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Levels of difficulty',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                      Column(
                        children: [
                          ActionButtonWidget(
                            text: 'Easy',
                            color: AppColors.blue,
                            borderRadius: 300,
                            onTap: () {
                              final LevelModel _level =
                              levelsRepository.firstWhere((level) =>
                              level.difficulty ==
                                  LevelDifficulty.easy);
                              context.router.push(GameRoute(level: _level));
                            },
                          ),
                          SizedBox(height: 10),
                          ActionButtonWidget(
                            text: 'Normal',
                            color: AppColors.purple,
                            borderRadius: 300,
                            onTap: () {
                              final LevelModel _level =
                                  levelsRepository.firstWhere((level) =>
                                      level.difficulty ==
                                      LevelDifficulty.normal);
                              context.router.push(GameRoute(level: _level));
                            },
                          ),
                          SizedBox(height: 10),
                          ActionButtonWidget(
                            text: 'Hard',
                            color: AppColors.red,
                            borderRadius: 300,
                            onTap: () {
                              final LevelModel _level =
                              levelsRepository.firstWhere((level) =>
                              level.difficulty ==
                                  LevelDifficulty.hard);
                              context.router.push(GameRoute(level: _level));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          context.router.push(SettingsRoute());
                        },
                        child: SvgPicture.asset(
                            'assets/images/elements/settings.svg'),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      context.router.popAndPush(HomeRoute());
                    },
                    child: SvgPicture.asset(
                        'assets/images/elements/back-arrow.svg'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
