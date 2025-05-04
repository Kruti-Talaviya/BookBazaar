import 'package:bookbazaar/pages/AddBook.dart';
import 'package:flutter/material.dart';
import 'package:bookbazaar/Widget/SettingButtons.dart';
import 'package:bookbazaar/Widget/Gen_Appbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Widget/CircularAvatar.dart';
import '../Widget/ProfileButton.dart';
import '../Widget/elevated_Button.dart';
import '../Widget/toast.dart';
import '../cards/BookCard.dart';
import '../config.dart';

class SAccountPage extends StatefulWidget {
  const SAccountPage({Key? key}) : super(key: key);
  @override
  State<SAccountPage> createState() => _SAccountPageState();
}

class _SAccountPageState extends State<SAccountPage> {
  String sellerId = '';

  String userId = '';
  String username = '';
  String email = '';
  String phoneNumber = '';
  String collegeName = '';
  String city = '';
  String photo = '';
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    _loadsellerid(); // Load the seller ID and then load data
  }

  void _loadsellerid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sellerId = prefs.getString('CSellerid') ?? 'User';
    });

    if (sellerId != 'User') {
      loaddata(); // Call loaddata() after sellerId is set
    }
  }

  void loaddata() async {
    final Uri url1 = Uri.parse('$sellerUrl/$sellerId'); // API endpoint
    var response = await http.get(url1);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        userId = jsonResponse['userId']['_id'] ?? ''; // Fallback if userId is null
        username = jsonResponse['username'] ?? '';
        email = jsonResponse['email'] ?? '';
        phoneNumber = jsonResponse['phoneNumber'] ?? '';
        collegeName = jsonResponse['collegeName'] ?? '';
        city = jsonResponse['city'] ?? '';

        // Handle the seller's photo URL, ensuring it's a string
        if (jsonResponse['photo'] is String) {
          String photourl = jsonResponse['photo'].replaceAll('\\', '/');
          photo = '$url' + '$photourl'; // Concatenate the sellerUrl and photo URL correctly
        } else {
          // Default photo URL
          photo = 'https://example.com/default_photo.png';
        }

        // Populate books safely with dynamic types and process book photos
        if (jsonResponse['books'] is List) {
          books = List<Map<String, dynamic>>.from(jsonResponse['books']);
          books = books.map((book) {
            if (book['photo'] is String) {
              String photoUrl = book['photo'].replaceAll('\\', '/'); // Replace backslashes
              book['photo'] = '$url' + '$photoUrl'; // Append the full URL
            }
            return book;
          }).toList();
        } else {
          books = []; // Assign empty list if books is not in the expected format
        }
      });
    } else {
      // Handle error or invalid response
      ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
    }
  }

  void _addbook() async {
    Navigator.pushNamed(context, "/addbook");
  }

  void _viewInsights() {

    Navigator.pushNamed(context, "/ViewInsightsPage");
  }
  void _vieworder() {

    Navigator.pushNamed(context, "/vieworder");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Profile',
        showBackArrow: false,
        showTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 140,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: UpdateAvatar(
                                radius: 60,
                                enableImagePicking: false,
                                onImagePicked: (pickedImageUrl) {},
                                initialImageUrl: photo,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileDetailRow('Name:', username),
                            _buildProfileDetailRow('City:', city),
                            _buildProfileDetailRow('College Name:', collegeName),
                            _buildProfileDetailRow('Email:', email),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // First Row with Edit and Add Book buttons
                    Row(
                      children: [
                        Expanded(
                          child: ProfileButton(
                            text: 'Edit',
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ProfileButton(
                            text: 'Add Book',
                            textColor: Colors.white,
                            onPressed: _addbook,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Second Row with Delete and Insights buttons
                    Row(
                      children: [
                        Expanded(
                          child: ProfileButton(
                            text: 'Orders',
                            textColor: Colors.white,
                            onPressed: _vieworder,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ProfileButton(
                            text: 'Insights',
                            textColor: Colors.white,
                            onPressed: _viewInsights, // Insights button functionality
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                    sellerName: username.toString() ?? 'Unknown Seller',
                    category: books[index]['category']?.toString() ?? 'Unknown',
                    id: books[index]['bookId']?.toString() ?? '',
                    sellerId: books[index]['sellerId']?.toString() ?? '',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
              fontSize: 17.00,
            ),
          ),
          SizedBox(width: 10),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 17.00,
            ),
          ),
        ],
      ),
    );
  }
}

