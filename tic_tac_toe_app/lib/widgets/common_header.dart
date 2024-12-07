import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final List<Widget>? actions; // Added this parameter

  // Constructor now accepts actions
  const CommonHeader({super.key, required this.pageTitle, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Tic-Tac-Toe",
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ), 
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF333333)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      elevation: 5.0, // Optional: Adds shadow
      shadowColor: Colors.grey.withOpacity(0.5),
      actions: actions, // This line uses the actions parameter
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}