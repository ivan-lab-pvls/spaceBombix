import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:space_bombs_app/router/router.dart';
import 'package:space_bombs_app/theme/colors.dart';
import 'package:space_bombs_app/widgets/action_button_widget.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Settings',
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
                          text: 'Share with friends',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            Share.share(
                                'Welcome to our game! Download here - https://apps.apple.com/us/app/the-space-war-bomb-match/id6476297871');
                          },
                        ),
                        SizedBox(height: 10),
                        ActionButtonWidget(
                          text: 'Privacy Policy',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Main(
                                    main: 'https://docs.google.com/document/d/1xYDzPW3oNOEg8x4zvsnuh-rF1XAo0NSTDrXSuagntAU/edit?usp=sharing'),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ActionButtonWidget(
                          text: 'Terms of use',
                          color: AppColors.blue,
                          borderRadius: 300,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Main(
                                    main: 'https://docs.google.com/document/d/1Z2UusfWZwpCGgedlT6pGs5OtYPLUUig0Jfz1ixoZ3xk/edit?usp=sharing'),
                              ),
                            );
                          },
                        ),
                      ],
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
                  child:
                      SvgPicture.asset('assets/images/elements/back-arrow.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.main});
  final String main;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  var _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              onLoadStop: (controller, url) {
                controller.evaluateJavascript(
                    source:
                        "javascript:(function() { var ele=document.getElementsByClassName('docs-ml-header-item docs-ml-header-drive-link');ele[0].parentNode.removeChild(ele[0]);var footer = document.getelementsbytagname('footer')[0];footer.parentnode.removechild(footer);})()");
              },
              onProgressChanged: (controller, progress) => setState(() {
                _progress = progress;
              }),
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.main),
              ),
            ),
            if (_progress != 100)
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
