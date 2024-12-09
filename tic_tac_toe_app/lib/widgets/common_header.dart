import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;

  //This will be called at the screens receiving the name as a parameter
  const CommonHeader({Key? key, required this.pageTitle}) : super(key: key);

  //The idea is to build a standardized header for all pages
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
              color: Color.fromARGB(255, 242, 242, 242),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
