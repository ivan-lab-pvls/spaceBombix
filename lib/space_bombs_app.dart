import 'package:flutter/material.dart';
import 'package:space_bombs_app/router/router.dart';

class SpaceBombsApp extends StatelessWidget {
  SpaceBombsApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(fontFamily: 'SF Pro Display'),
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}