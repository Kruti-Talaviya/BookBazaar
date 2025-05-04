import 'dart:convert';
import 'package:bookbazaar/Widget/SearchBar.dart'as custom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Widget/AppBar.dart';
import '../Widget/Gen_Appbar.dart';
import '../config.dart';
import 'package:bookbazaar/cards/BookCard.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    _loadbooks();
  }

  void _loadbooks() async {
    final Uri url1 = Uri.parse('$bookUrl/get'); // API endpoint
    try {
      var response = await http.get(url1);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          if (jsonResponse['books'] is List) {
            books = List<Map<String, dynamic>>.from(jsonResponse['books']);
            books = books.map((book) {
              if (book['photo'] is String) {
                String photoUrl = book['photo'].replaceAll('\\', '/');
                book['photo'] = '$url' + '$photoUrl';
              }
              return book;
            }).toList();
            print(books);
          } else {
            books = [];
          }
        });
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (error) {
      print("Failed to load books: $error");
    }
  }

  void searchCategory(String query) {
    setState(() {
      if (query.isEmpty) {
        _loadbooks();
      } else {
        books = books.where((book) {
          final title = book['title']?.toString().toLowerCase() ?? '';
          final category = book['category']?.toString().toLowerCase() ?? '';

          return title.contains(query.toLowerCase()) || category.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Category',
        showBackArrow: false,
        showTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          custom.SearchBar(
            searchCategory: searchCategory,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return BookCard(
                  imageUrl: books[index]['photo'] as String? ?? 'default_image.png',
                  title: books[index]['title']?.toString() ?? 'No Title',
                  price: books[index]['price']?.toString() ?? 'Unknown Price',
                  sellerName: books[index]['username']?.toString() ?? 'Unknown Seller',
                  category: books[index]['category']?.toString()??'UnKnown',
                  id: books[index]['bookId']?.toString() ?? '',
                  sellerId: books[index]['sellerId']?.toString() ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
