import 'package:flutter/material.dart';
import 'pages/game.dart';
import 'pages/ranks.dart';
import 'pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home', // Set initial route to the Game screen
      routes: {
        '/game': (context) => const GameScreen(),
        '/home': (context) => const HomeScreen(),
        '/ranks': (context) => const RanksScreen(),
      },
    );
  }
}
