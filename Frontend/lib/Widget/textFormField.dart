import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon; // Make the prefixIcon nullable
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxlines;
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.prefixIcon, // Remove the `required` keyword to make it optional
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.maxlines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        // Conditionally add the prefix icon if it's not null
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF004aad), // Same color as your theme
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
