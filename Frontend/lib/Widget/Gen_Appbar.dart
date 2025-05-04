import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackArrow;
  final bool showTitle;

  const SimpleAppBar({
    Key? key,
    this.title, // Title is optional now
    this.showBackArrow = true, // Control visibility of back arrow
    this.showTitle = true, // Control visibility of title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackArrow
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: const Color(0xFF004aad)),
        onPressed: () {
          Navigator.of(context).pop(); // Go back when pressed
        },
      )
          : null, // If `showBackArrow` is false, hide the back arrow
      title: showTitle
          ? Text(
        title ?? '', // Use empty string if no title provided
        style: const TextStyle(
          color: const Color(0xFF004aad),
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      )
          : null, // If `showTitle` is false, don't show the title
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 1.0,

    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

