import 'package:flutter/material.dart';

class VictoryPage extends StatelessWidget {
  final String winner;

  const VictoryPage({super.key, required this.winner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Victory Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$winner Won!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/match');
              },
              child: const Text('Rematch'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/player_info');
              },
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}
