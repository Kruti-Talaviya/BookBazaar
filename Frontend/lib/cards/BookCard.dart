import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/BookDetailPage.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String sellerName;
  final String id;
  final String? category;
  final String? sellerId;

  const BookCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.sellerName,
    required this.category,
    required this.id, // Keep the id as a required field
    this.sellerId, // Make sellerId optional by using String?
    super.key,
  });

  Future<void> _saveBookId(String bookId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookid', bookId);  // Save the id with key 'bookid'
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

        await _saveBookId(id);


        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(),
          ),
        );
      },

      child: Container(

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5.0,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xFF004aad),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Color(0xFF004aad),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  sellerName,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
