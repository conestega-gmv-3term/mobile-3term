import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  // Constructor that takes the players names as optional and set a default.
  const GameScreen({
    Key? key,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Define a 3x3 board for Tic Tac Toe
  List<List<String>> board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  String currentPlayer = 'X'; // 'X' starts the game
  String? winner; // Winner state

  // Handle player move
  void handleTap(int row, int col) {
    if (board[row][col] == '' && winner == null) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          winner = currentPlayer;
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X'; // Switch turns
        }
      });
    }
  }

  // Check if the current move resulted in a win
  bool checkWinner(int row, int col) {
    // Check row
    if (board[row].every((cell) => cell == currentPlayer)) return true;

    // Check column
    if (board.every((r) => r[col] == currentPlayer)) return true;

    // Check main diagonal
    if (row == col &&
        board.every((r) => r[board.indexOf(r)] == currentPlayer)) {
      return true;
    }

    // Check anti-diagonal
    if (row + col == 2 &&
        board.every((r) => r[2 - board.indexOf(r)] == currentPlayer)) {
      return true;
    }

    return false;
  }

  // Reset the game
  void resetGame() {
    setState(() {
      board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', ''],
      ];
      currentPlayer = 'X';
      winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Game Board'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Padding(padding: EdgeInsets.only(top:15)),
          // Display the winner or current turn
          Text(
            winner != null
                ? 'Winner: $winner'
                : 'Current Turn: $currentPlayer (${currentPlayer == 'X' ? widget.player1 : widget.player2})',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), 
          ),
          const SizedBox(height: 20.0),
          // Build the board dynamically
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3x3 grid
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return GestureDetector(
                  onTap: () => handleTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Colors.blue.shade100,
                    ),
                    child: Center(
                      child: Text(
                        board[row][col],
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: board[row][col] == 'X'
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
            Container(
            padding: const EdgeInsets.all(2), margin: const EdgeInsets.only(bottom: 10),child:Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 20.0), ElevatedButton(onPressed: resetGame, child: const Text('Restart Game', style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))), 
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(const Color.fromARGB(255, 67, 168, 250)))),
            ])
            ),
        ],
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}
