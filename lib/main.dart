import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_bombs_app/space_bombs_app.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(SpaceBombsApp());
}
