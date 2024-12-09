import 'package:flutter/material.dart';
import 'pages/playerinfo.dart';
import 'pages/game.dart';
import 'pages/ranks.dart';
import 'pages/home.dart';
import 'widgets/common_header.dart';
import 'widgets/common_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home', // Set initial route to the Game screen
      routes: {
        '/game': (context) => GameScreen(),
        '/home': (context) => HomeScreen(),
        '/ranks': (context) => RanksScreen(),
      },
    );
  }
}
