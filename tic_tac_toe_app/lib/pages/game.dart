import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  // Constructor that takes the players names as optional and set a default.
  const GameScreen({
    super.key,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
  });

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

// Function to check if the game has ended in a draw
  bool isDraw() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty)) &&
        winner == null;
  }

  Future<void> updateScore() async {
    if (winner != null) {
      final winnerName = (winner == 'X' ? widget.player1 : widget.player2);
      final prefs = await SharedPreferences.getInstance();
      final playersString = prefs.getString('players');
      if (playersString != null) {
        final players = Map<String, dynamic>.from(jsonDecode(playersString));
        final player = players[winnerName];
        if (player != null) {
          player['score'] = (player['score'] ?? 0) + 1;
          await prefs.setString('players', jsonEncode(players));
        }
      }
    }
  }

  // Handle player move
  void handleTap(int row, int col) {
    if (board[row][col] == '' && winner == null) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          winner = currentPlayer;
          updateScore();
        } else if (isDraw()) {
          // Handle draw if needed
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X'; // Switch turns
        }
      });
    }
  }

  // Check if the current move resulted in a win
  bool checkWinner(int row, int col) {
    if (board[1][1] == board[1][0] &&
        board[1][1] == board[1][2] &&
        board[1][1] != "") {
      return true;
    }
    if (board[1][1] == board[0][1] &&
        board[1][1] == board[2][1] &&
        board[1][1] != "") {
      return true;
    }
    if (board[1][1] == board[0][0] &&
        board[1][1] == board[2][2] &&
        board[1][1] != "") {
      return true;
    }
    if (board[1][1] == board[0][2] &&
        board[1][1] == board[2][0] &&
        board[1][1] != "") {
      return true;
    }
    if (board[1][0] == board[0][0] &&
        board[1][0] == board[2][0] &&
        board[1][0] != "") {
      return true;
    }
    if (board[1][2] == board[0][2] &&
        board[1][2] == board[2][2] &&
        board[1][2] != "") {
      return true;
    }
    if (board[0][0] == board[0][1] &&
        board[0][0] == board[0][2] &&
        board[0][0] != "") {
      return true;
    }
    if (board[2][0] == board[2][1] &&
        board[2][0] == board[2][2] &&
        board[2][0] != "") {
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
        children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          // Display the winner or current turn
          Text(
            winner != null
                ? 'Winner: $winner  (${winner == 'X' ? widget.player1 : widget.player2})'
                : 'Current Turn: $currentPlayer (${currentPlayer == 'X' ? widget.player1 : widget.player2})',
            style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 400,
            width: 400,
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3x3 grid
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                var row;
                var col;

                //identify the position of the square
                switch (index) {
                  case 0:
                    row = 0;
                    col = 0;

                  case 1:
                    row = 0;
                    col = 1;

                  case 2:
                    row = 0;
                    col = 2;

                  case 3:
                    row = 1;
                    col = 0;

                    break;
                  case 4:
                    row = 1;
                    col = 1;

                  case 5:
                    row = 1;
                    col = 2;

                  case 6:
                    row = 2;
                    col = 0;

                  case 7:
                    row = 2;
                    col = 1;

                    break;
                  case 8:
                    row = 2;
                    col = 2;
                }
                return GestureDetector(
                  onTap: () => handleTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: const Color.fromARGB(255, 226, 237, 246),
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
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(bottom: 10),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: resetGame,
                    child: const Text('Restart Game',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
              ])),
        ],
      ),
      backgroundColor: const Color.fromRGBO(48, 84, 227, 89),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}
