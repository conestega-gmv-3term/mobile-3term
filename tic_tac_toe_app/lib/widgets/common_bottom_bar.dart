import 'package:flutter/material.dart';

class CommonBottomBar extends StatelessWidget {
  const CommonBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current route name
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Material(
      elevation: 5.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      child: BottomAppBar(
        child: Container(
          // Here I'm wrapping the bottomAppBar with a container so I can add a gradient effect
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF000000), Color(0xFF333333)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home Button
              GestureDetector(
                onLongPress: () => _showTooltip(context, "Home"),
                child: IconButton(
                  icon: Icon(
                    Icons.home,
                    color: currentRoute == '/home' ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                ),
              ),
              // Quick Match Button
              GestureDetector(
                onLongPress: () => _showTooltip(context, "Quick Match"),
                child: IconButton(
                  icon: Icon(
                    Icons.videogame_asset,
                    color: currentRoute == '/game' ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                ),
              ),
              // Ranks Button
              GestureDetector(
                onLongPress: () => _showTooltip(context, "Ranks"),
                child: IconButton(
                  icon: Icon(
                    Icons.star,
                    color:
                        currentRoute == '/ranks' ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/ranks');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to create a floating text for the bottom bar
  void _showTooltip(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom:
            100.0, // Here I can adjust the hight of where it will be displayed
        left: MediaQuery.of(context).size.width * 0.4,
        child: Material(
          color: Colors.transparent,
          // Here I'm creating a box to contain the text with the name of the button
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // I'm removing the tooltip after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
