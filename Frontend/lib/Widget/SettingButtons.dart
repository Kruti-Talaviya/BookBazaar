import 'package:flutter/material.dart';

class CustomSettingsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap; // Add an optional onTap callback

  const CustomSettingsButton({
    Key? key,
    required this.icon,
    required this.title,

    this.onTap, // Initialize onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF004aad)),
        title: Text(
          title,
          style: const TextStyle(
            color: const Color(0xFF004aad),
            fontSize: 16.0,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF004aad),
              size: 16.0,
            ),
          ],
        ),
        onTap: onTap, // Trigger onTap when the button is pressed
      ),
    );
  }
}