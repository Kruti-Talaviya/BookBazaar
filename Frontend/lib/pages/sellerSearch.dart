import 'dart:convert';
import 'package:bookbazaar/Widget/SearchBar.dart'as custom;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Widget/AppBar.dart';
import '../Widget/Gen_Appbar.dart';
import '../cards/SellerCard.dart';
import '../config.dart';
import 'package:bookbazaar/cards/BookCard.dart';

class sellerSearchPage extends StatefulWidget {
  const sellerSearchPage({super.key});

  @override
  _sellerSearchPageState createState() => _sellerSearchPageState();
}

class _sellerSearchPageState extends State<sellerSearchPage> {
  List<Map<String, dynamic>> sellers = [];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchSellers();
  }

  Future<void> _fetchSellers() async {
    final Uri url1 = Uri.parse('$sellerUrl/get'); // API endpoint

    try {
      var response = await http.get(url1);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        setState(() {
          if (jsonResponse['sellers'] is List) {
            sellers = List<Map<String, dynamic>>.from(jsonResponse['sellers']);
            sellers = sellers.map((seller) {
              if (seller['photo'] is String) {
                String photoUrl = seller['photo'].replaceAll('\\', '/');
                seller['photo'] = '$url' + '$photoUrl';
              }
              return seller;
            }).toList();

          } else {
            sellers = [];
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
        _fetchSellers();
      } else {
        sellers = sellers.where((seller) {
          final title = seller['username']?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const SimpleAppBar(
        title: 'Sellers',
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
            child: ListView.builder(
              itemCount: sellers.length,
              itemBuilder: (context, index) {
                final seller = sellers[index]; // Access individual seller by index
                return SellerCard(
                  username: seller['username']?.toString() ?? 'Unknown',
                  collegeName: seller['collegeName']?.toString() ?? 'Unknown',
                  photo: seller['photo']?.toString() ?? '',
                  sellerid: seller['sellerId']?.toString() ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}