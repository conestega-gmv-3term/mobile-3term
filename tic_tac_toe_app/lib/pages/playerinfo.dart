import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'game.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';

class PlayerInfoScreen extends StatefulWidget {
  const PlayerInfoScreen({Key? key}) : super(key: key);

  @override
  State<PlayerInfoScreen> createState() => _PlayerInfoScreenState();
}

class _PlayerInfoScreenState extends State<PlayerInfoScreen> {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();
  final Map<String, Map<String, dynamic>> players = {};
  String? player1Avatar;
  String? player2Avatar;

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  // Load players from SharedPreferences
  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersString = prefs.getString('players');
    if (playersString != null) {
      setState(() {
        players.addAll(Map<String, Map<String, dynamic>>.from(
          jsonDecode(playersString),
        ));
      });
    }
  }

  // Save players to SharedPreferences
  Future<void> savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('players', jsonEncode(players));
  }

  // Pick an image (camera or gallery)
  Future<void> pickImage(bool isPlayer1) async {
    final ImagePicker picker = ImagePicker();

    // Pick image from camera
    final XFile? image = await picker.pickImage(
      source: ImageSource
          .camera, // Here I'm selecting the camera (could be gallery)
    );

    if (image != null) {
      setState(() {
        if (isPlayer1) {
          player1Avatar = image.path;
        } else {
          player2Avatar = image.path;
        }
      });
    }
  }

  void startGame() {
    // I'm making sure if the player don't put a name, a default Player 1 and Player 2 is send to the game screen
    final player1Name =
        player1Controller.text.isEmpty ? 'Player 1' : player1Controller.text;
    final player2Name =
        player2Controller.text.isEmpty ? 'Player 2' : player2Controller.text;

    // Creating the Player instances to save
    final player1 = {
      'name': player1Name,
      'avatar': player1Avatar,
      'score': players[player1Name]?['score'] ?? 0,
    };

    final player2 = {
      'name': player2Name,
      'avatar': player2Avatar,
      'score': players[player2Name]?['score'] ?? 0,
    };

    setState(() {
      players[player1['name'] as String] = player1;
      players[player2['name'] as String] = player2;
    });

    // Save the player into the map
    savePlayers();

    // Send it to the GameScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          player1: player1['name'] as String,
          player2: player2['name'] as String,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // I'm using the CommonHeader we design for all screens
      appBar: const CommonHeader(pageTitle: 'Player info'),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Wrapping around a Container so I can apply the style
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 167, 144, 249),
                    Color.fromRGBO(20, 57, 204, 0.655),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Enter your details',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      buildPlayerRow(
                        'Player 1 Name',
                        player1Controller,
                        player1Avatar,
                        players.keys.toList(),
                        true,
                      ),
                      const SizedBox(height: 20.0),
                      buildPlayerRow(
                        'Player 2 Name',
                        player2Controller,
                        player2Avatar,
                        players.keys.toList(),
                        false,
                      ),
                      const SizedBox(height: 40.0),
                      ElevatedButton.icon(
                        onPressed: startGame,
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Start Match',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(48, 84, 227, 89),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 32.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }

  // Widget to set the PlayerRow
  Widget buildPlayerRow(
    String label,
    TextEditingController controller,
    String? avatar,
    List<String> playerNames,
    bool isPlayer1,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () =>
                  pickImage(isPlayer1), // Trigger pickImage method on tap
              child: CircleAvatar(
                radius: 30, // Making it round
                backgroundColor: Colors.grey[300], // Placeholder background
                child: avatar == null
                    ? const Icon(Icons.camera_alt,
                        size:
                            30) // I'm showing the camera icon if there is no avatar
                    : ClipOval(
                        child: Image.file(
                          File(avatar),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown to select player from the list
                  DropdownButtonFormField<String>(
                    value: controller.text.isEmpty ? null : controller.text,
                    decoration: InputDecoration(
                      labelText: label,
                      border: const OutlineInputBorder(),
                    ),
                    items: playerNames.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.text = value;
                        // Check if the selected player has an avatar
                        if (players.containsKey(value)) {
                          final selectedPlayerAvatar =
                              players[value]?['avatar'];
                          setState(() {
                            if (isPlayer1) {
                              player1Avatar = selectedPlayerAvatar;
                            } else {
                              player2Avatar = selectedPlayerAvatar;
                            }
                          });
                        }
                      }
                    },
                    onSaved: (value) {
                      controller.text = value ?? '';
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Or type a new name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
