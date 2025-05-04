import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookbazaar/cards/BookCard.dart';
import 'package:bookbazaar/cards/CategoryButton.dart';
import 'package:http/http.dart' as http;
import '../Widget/AppBar.dart';
import '../config.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = '';

  List<Map<String,dynamic>> books = [];


  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadbooks();
  }
  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('Cusername') ?? 'User';

    });
  }

  void _loadbooks() async{
    final Uri url1 = Uri.parse('$bookUrl/get'); // API endpoint
    var response = await http.get(url1);
    var jsonResponse = jsonDecode(response.body);
    // print(jsonResponse);
    if (response.statusCode == 200){
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

        } else {
          books = [];
        }
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(username: username),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          // Books grid
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


