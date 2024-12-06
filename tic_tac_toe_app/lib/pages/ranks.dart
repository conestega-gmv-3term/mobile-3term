import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_toe_app/widgets/common_header.dart';
import 'package:tic_tac_toe_app/widgets/common_bottom_bar.dart';
import 'dart:io';

class RanksScreen extends StatefulWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  _RanksScreenState createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  List<Map<String, dynamic>> _players = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  // Method to load players from SharedPreferences
  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersString = prefs.getString('players');
    if (playersString != null) {
      final players = Map<String, dynamic>.from(jsonDecode(playersString));
      
      // Sort players by score in descending order
      final sortedPlayers = players.entries.map((entry) {
        return {
          'name': entry.key,
          'score': entry.value['score'] as int? ?? 0,
          'avatar': entry.value['avatar'],
        };
      }).toList()
      ..sort((a, b) => b['score'].compareTo(a['score']));

      setState(() {
        _players = sortedPlayers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonHeader(pageTitle: 'Player Rankings'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 167, 144, 249),
              Color.fromRGBO(20, 57, 204, 0.655),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _players.isEmpty
            ? Center(child: Text('No players in the rankings yet.'))
            : ListView.builder(
                itemCount: _players.length,
                itemBuilder: (context, index) {
                  final player = _players[index];
                  return ListTile(
                    leading: player['avatar'] != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(File(player['avatar'])),
                          )
                        : Icon(Icons.person),
                    title: Text(player['name']),
                    trailing: Text('Score: ${player['score']}'),
                  );
                },
              ),
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}