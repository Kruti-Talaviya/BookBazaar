import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String text;

  final Color textColor;
  final VoidCallback onPressed;

  ProfileButton({
    required this.text,

    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // backgroundColor:Color(0xFF004aad),
        backgroundColor:Colors.blue[800],
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 18),
      ),
    );
  }
}
