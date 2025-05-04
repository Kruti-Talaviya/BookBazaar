import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;

  const CustomAppBar({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/appbar.jpg', // Replace with your image path
              fit: BoxFit.cover, // To make the image cover the AppBar area
            ),
          ),

          // AppBar content (with transparent background)
          AppBar(
            automaticallyImplyLeading: false, // To hide the back button
            backgroundColor: Colors.transparent, // Make the AppBar transparent
            elevation: 0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 40.0, right: 20.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome, $username', // Display user's name
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Let's learn together", // Static subtitle text
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                  // const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
