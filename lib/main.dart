import 'package:android_detente_camoel/ui/screens/connexion/connexion.dart';
import 'package:flutter/material.dart';
import 'package:android_detente_camoel/theme.dart';
import 'package:android_detente_camoel/ui/screens/HomePageScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo + API',
      theme: myTheme,
      home: HomePageScreen(),
    );
  }
}
