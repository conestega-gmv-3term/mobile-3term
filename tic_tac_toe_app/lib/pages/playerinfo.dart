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
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
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

  File? selectedImage;

  Future getImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  Future getImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  void startGame() {
    final player1 = {
      'name': player1Controller.text,
      'avatar': player1Avatar,
      'score': players[player1Controller.text]?['score'] ?? 0,
    };

    final player2 = {
      'name': player2Controller.text,
      'avatar': player2Avatar,
      'score': players[player2Controller.text]?['score'] ?? 0,
    };

    setState(() {
      players[player1['name'] as String] = player1;
      players[player2['name'] as String] = player2;
    });

    savePlayers();

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
      appBar: const CommonHeader(pageTitle: 'Player info'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Enter your details',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            buildPlayerRow(
              'Player 1 Name',
              player1Controller,
              () => pickImage(true),
              player1Avatar,
              players.keys.toList(), // Pass the list of saved player names
            ),
            buildPlayerRow(
              'Player 2 Name',
              player2Controller,
              () => pickImage(false),
              player2Avatar,
              players.keys.toList(),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton.icon(
              onPressed: startGame,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Match'),
            ),
            const SizedBox(height: 20.0),
            buildSavedPlayersDebugWidget(),
          ],
        ),
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }

  Widget buildPlayerRow(
    String label,
    TextEditingController controller,
    VoidCallback onPickImage,
    String? avatar,
    List<String>
        playerNames, // Add this parameter to pass existing player names
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPickImage,
          child: avatar == null
              ? const Placeholder(fallbackWidth: 50, fallbackHeight: 50)
              : Image.file(File(avatar),
                  width: 50, height: 50, fit: BoxFit.cover),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                onChanged: (value) {
                  // Optionally validate or update the player list dynamically
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Debug widget to display saved players
  Widget buildSavedPlayersDebugWidget() {
    return Expanded(
      child: ListView(
        children: players.entries
            .map(
              (entry) => ListTile(
                leading: entry.value['avatar'] != null
                    ? Image.file(
                        File(entry.value['avatar']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.person),
                title: Text(entry.key),
                subtitle: Text('Score: ${entry.value['score']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
