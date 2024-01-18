import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space_bombs_app/models/level_model.dart';
import 'package:space_bombs_app/router/router.dart';
import 'package:space_bombs_app/theme/colors.dart';
import 'package:space_bombs_app/widgets/action_button_widget.dart';

@RoutePage()
class PauseScreen extends StatefulWidget {
  final LevelModel level;
  const PauseScreen({super.key, required this.level});

  @override
  State<PauseScreen> createState() => _PauseScreenState();
}

class _PauseScreenState extends State<PauseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pause',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        ActionButtonWidget(
                          text: 'Continue',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            context.router.popAndPush(GameRoute(level: widget.level));
                          },
                        ),
                        SizedBox(height: 10),
                        ActionButtonWidget(
                          text: 'Restart',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            context.router.push(GameRoute(level: widget.level));
                          },
                        ),
                        SizedBox(height: 10),
                        ActionButtonWidget(
                          text: 'Levels of difficulty',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            context.router.push(LevelsRoute());
                          },
                        ),
                        SizedBox(height: 10),
                        ActionButtonWidget(
                          text: 'To main',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            context.router.push(HomeRoute());
                          },
                        ),
                        SizedBox(height: 10),
                
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
            ],
          ),
        ),
      ),
    );
  }
}
