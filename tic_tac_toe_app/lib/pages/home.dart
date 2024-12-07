import 'package:flutter/material.dart';
import 'playerinfo.dart';
import 'ranks.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Home'),
      body: Column(
        children: [
            Container(
            padding: const EdgeInsets.all(20), margin: const EdgeInsets.all(3.5),child:const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Welcome to the game!", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 255, 255)))])
            ),
            Container(
            padding: const EdgeInsets.all(0), margin: const EdgeInsets.only(top: 100),child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 60.0), ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(  Color.fromARGB(255, 255, 255, 255))),onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const PlayerInfoScreen()),
              );
            },
            child: const Text('New Game', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            )
            ])
            ),
            Container(
            padding: const EdgeInsets.all(7), margin: const EdgeInsets.all(3.5),child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 60.0), ElevatedButton(style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 255, 255, 255))),onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const RanksScreen()),
              );
            },
            child: const Text('Ranks',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            )
            ])
            ),
        ],
      ), backgroundColor: const Color.fromRGBO(69, 48, 227, 89),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}
