import 'package:flutter/material.dart';
import 'playerinfo.dart';
import 'ranks.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Home'),
      body: Column(
        children: [
            Container(
            padding: const EdgeInsets.all(20), margin: const EdgeInsets.all(3.5),child:const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Welcome to the game!", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold))])
            ),
            Container(
            padding: const EdgeInsets.all(1), margin: const EdgeInsets.all(3.5),child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/default.png')])
            ),
            Container(
            padding: const EdgeInsets.all(0), margin: const EdgeInsets.only(top: 50),child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 40.0), ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(const Color.fromARGB(255, 67, 168, 250))),onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const PlayerInfoScreen()),
              );
            },
            child: const Text('New Game', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            )
            ])
            ),
            Container(
            padding: const EdgeInsets.all(7), margin: const EdgeInsets.all(3.5),child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 20.0), ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(const Color.fromARGB(255, 67, 168, 250))),onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => const RanksScreen()),
              );
            },
            child: const Text('Ranks',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            )
            ])
            ),
        ],
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}
