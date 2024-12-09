import 'package:flutter/material.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  
  const GameScreen({
    Key? key,
    this.player1 = "Player 1",
    this.player2 = "Player 2",
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}
class _GameScreenState extends State<GameScreen> {
  
  //The positions of the Game
  List<List<String>> board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];

  String currentPlayer = 'X'; // First to play
  String? winner; //If there is a winner
  int isDraw=0; //Check if it IS a draw

  //If the player taps a square
  void isTap(int row, int col) {
    isDraw++;
    if (isDraw != 9 && winner == null) {
      
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWinner(row, col)) 
        {
          winner = currentPlayer;
        } 
        else 
        {
          if(currentPlayer=="X")
          {
            currentPlayer = "O";
          }
          else
          {
            currentPlayer = "X";
          }
        }
      });
    }
  }

  // Check if there is a winner
  bool checkWinner(int row, int col) {

    if(board[1][1]==board[1][0] && board[1][1]==board[1][2] && board[1][1]!="")
    {
      return true;
    }
    if(board[1][1]==board[0][1] && board[1][1]==board[2][1] && board[1][1]!="")
    {
      return true;
    }
    if(board[1][1]==board[0][0] && board[1][1]==board[2][2] && board[1][1]!="")
    {
      return true;
    }
    if(board[1][1]==board[0][2] && board[1][1]==board[2][0] && board[1][1]!="")
    {
       return true;
    }
    if(board[1][0]==board[0][0] && board[1][0]==board[2][0] && board[1][0]!="")
    {
       return true;
    }
    if(board[1][2]==board[0][2] && board[1][2]==board[2][2] && board[1][2]!="")
    {
       return true;
    }
    if(board[0][0]==board[0][1] && board[0][0]==board[0][2] && board[0][0]!="")
    {
       return true;
    }
    if(board[2][0]==board[2][1] && board[2][0]==board[2][2] && board[2][0]!="")
    {
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
      isDraw=0;
    });
  }
  
  //Display the message
  String checkMessage()
  {
    if(winner!=null)
    {
      return "Winner: $winner";
    }
    else if(isDraw==9)
    {
      return "It is a Draw";
    }
    else
    {
      return "Current Turn: $currentPlayer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Game Board'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Text( "${checkMessage()}"),
          SizedBox(
            height: 400, width: 400,
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //3 per line
                mainAxisSpacing: 8, //spacing
                crossAxisSpacing: 8,
              ),
              itemCount: 9, //Nine Squares
              itemBuilder: (context, index) {
                var row;
                var col;

                //identify the position of the square
                switch (index) {
                  case 0:
                  row =0;
                  col =0;

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
                
                return InkWell(
                  onTap: () => isTap(row, col), //Tap
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: const Color.fromARGB(255, 226, 237, 246),
                    ),
                    child: Center(
                      child: Text(board[row][col], style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color:  Color.fromARGB(255, 0, 0, 0))),
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
                ElevatedButton(
                    onPressed: resetGame,
                    child: const Text('Restart Game', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
              ])),
        ],
      ), 
      backgroundColor: const Color.fromRGBO(48, 84, 227, 89), //Background color
      bottomNavigationBar: const CommonBottomBar(), 
    );
  }
}
