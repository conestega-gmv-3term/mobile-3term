import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class VictoryPage extends StatelessWidget {
  final String winner;

  VictoryPage({required this.winner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Victory Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$winner Won!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/match');
              },
              child: Text('Rematch'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/player_info');
              },
              child: Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
