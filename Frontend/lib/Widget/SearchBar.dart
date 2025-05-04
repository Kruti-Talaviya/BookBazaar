import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) searchCategory;

  const SearchBar({
    Key? key,
    required this.searchCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintText: "Type to search",
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (text) {
            searchCategory(text); // Trigger search on enter
          },
        ),
      ),
    );
  }
}
