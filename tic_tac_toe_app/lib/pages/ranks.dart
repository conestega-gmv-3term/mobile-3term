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
  List<Map<String, dynamic>> _topThreeByScore = [];
  bool _isScoreSorted = true; // Initially sort by score

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersString = prefs.getString('players');
    if (playersString != null) {
      final players = Map<String, dynamic>.from(jsonDecode(playersString));
      
      // Load players and sort them by score to determine top three
      List<Map<String, dynamic>> sortedByScore = players.entries.map((entry) {
        return {
          'name': entry.key,
          'score': entry.value['score'] as int? ?? 0,
          'avatar': entry.value['avatar'],
        };
      }).toList();
      sortedByScore.sort((a, b) => b['score'].compareTo(a['score']));

      // Save the top three based on score
      _topThreeByScore = sortedByScore.sublist(0, sortedByScore.length >= 3 ? 3 : sortedByScore.length);

      // Now sort players based on current sorting method
      _sortPlayers(players);
    }
  }

  void _sortPlayers(Map<String, dynamic> players) {
    List<Map<String, dynamic>> sortedPlayers = players.entries.map((entry) {
      return {
        'name': entry.key,
        'score': entry.value['score'] as int? ?? 0,
        'avatar': entry.value['avatar'],
      };
    }).toList();

    if (_isScoreSorted) {
      sortedPlayers.sort((a, b) => b['score'].compareTo(a['score']));
    } else {
      sortedPlayers.sort((a, b) => a['name'].compareTo(b['name']));
    }

    setState(() {
      _players = sortedPlayers;
    });
  }

  void _toggleSort() {
    setState(() {
      _isScoreSorted = !_isScoreSorted;
    });
    _loadPlayers(); // Reload and sort players, but keep top three from score sorting
  }

  Widget _buildPlaceIcon(String playerName) {
    int index = _topThreeByScore.indexWhere((player) => player['name'] == playerName);
    switch (index) {
      case 0:
        return Icon(Icons.stars, color: Colors.amber);
      case 1:
        return Icon(Icons.star, color: Colors.grey[400]);
      case 2:
        return Icon(Icons.star_half, color: Colors.brown);
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHeader(
        pageTitle: 'Player Rankings', 
        actions: [
          IconButton(
            icon: Icon(_isScoreSorted ? Icons.sort_by_alpha : Icons.leaderboard),
            onPressed: _toggleSort,
          ),
        ],
      ),
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
                    title: Row(
                      children: [
                        _buildPlaceIcon(player['name']),
                        SizedBox(width: 10),
                        Text(
                          player['name'],
                          style: TextStyle(
                            color: _topThreeByScore.any((p) => p['name'] == player['name']) 
                              ? (_topThreeByScore.indexOf(player) == 0 ? Colors.amber : 
                                 _topThreeByScore.indexOf(player) == 1 ? Colors.grey[400] : Colors.brown) 
                              : null,
                            fontWeight: _topThreeByScore.any((p) => p['name'] == player['name']) 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    trailing: Text('Score: ${player['score']}'),
                  );
                },
              ),
      ),
      bottomNavigationBar: const CommonBottomBar(),
    );
  }
}