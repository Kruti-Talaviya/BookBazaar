import 'package:bookbazaar/config.dart';
import 'package:flutter/material.dart';

import 'package:bookbazaar/Widget/Gen_Appbar.dart';

import 'dart:convert';
import 'package:bookbazaar/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/ProfileButton.dart';
import '../Widget/toast.dart';
import '../cards/SellerCard.dart';


class BookDetailPage extends StatefulWidget {


  const BookDetailPage({
    super.key,
  });

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isSeller = false;
  String Csellerid = '';

  String title = '';
  int price = 0;
  String photo = '';
  String description = '';
  String category = '';
  String sellerId = '';
  String BookId = '';
  String author = '';
  String buyer = '';
  String userId = '';
  String username = '';
  String collegeName = '';
  String sellerphoto = '';
  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }
  Future<void> _getBookId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BookId = prefs.getString('bookid') ?? '';
      isSeller = prefs.getBool('isSeller') ?? false;
      Csellerid=prefs.getString('CSellerid') ?? '';
    });
  }
  Future<void> _fetchBookDetails() async {

    await _getBookId();
    // print(BookId);
    final Uri url1 = Uri.parse('$bookUrl/bookid/$BookId');

    var response = await http.get(url1);
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    if (jsonResponse['status'] != null && jsonResponse['status'] == true) {
      setState(() {
        title = jsonResponse['title'] ?? '';
        price = jsonResponse['price'] ?? 0;
        description = jsonResponse['description'] ?? '';
        category = jsonResponse['category'] ?? '';
        sellerId = jsonResponse['sellerId'] ?? '';
        author = jsonResponse['author']?? '';
        buyer = jsonResponse['buyer']?? '';
        if (jsonResponse['photo'] is String && jsonResponse['photo'].isNotEmpty) {
          String photourl = jsonResponse['photo'].replaceAll('\\', '/');
                photo = '$url' + '$photourl'; // Concatenate the sellerUrl and photo URL correctly
        } else {
          // Default photo URL
          photo = 'https://example.com/default_photo.png';
        }
      // });
      _loadseller();
    });
    }else {
      ToastUtils.showToast(jsonResponse['message'] ?? 'Error occurred', Colors.red, Colors.white);
    }
  }
  void _loadseller() async{
    final Uri url1 = Uri.parse('$sellerUrl/$sellerId');
    var response = await http.get(url1);
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status']) {
      setState(() {
        userId = jsonResponse['userId']['_id'] ?? '';
        username = jsonResponse['username'] ?? '';
        collegeName = jsonResponse['collegeName'] ?? '';

        if (jsonResponse['photo'] is String) {
          String photourl = jsonResponse['photo'].replaceAll('\\', '/');
          sellerphoto = '$url' + '$photourl';
        } else {
          // Default photo URL
          photo = 'https://example.com/default_photo.png';
        }
      });
    } else {
      ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
    }
  }
  void _buynow()async{
    Navigator.pushNamed(context, "/buynow");
  }
  void _updatebook() async {
    print ("updating the book");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Book Details',
        showBackArrow: true,
        showTitle: true,
      ),
      body: SingleChildScrollView(  // Scrollable container
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: IntrinsicHeight(
                      child: Image.network(
                        photo,
                        fit: BoxFit.contain,  // Adjust the fit to maintain the aspect ratio without cropping
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),  // Show error icon if image fails
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),  // Add space

              // Book Title
              Container(
                padding: const EdgeInsets.all(16.0), // Add padding inside the container
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
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    // Book Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004aad), // Blue text for title
                      ),
                    ),

                    const SizedBox(height: 8.0), // Add space

                    // Book Price
                    Text(
                      'Price: ₹$price',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8.0), // Add space
                    // Book Author
                    Text(
                      'Author : $author',
                      style:  TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                    ),
                    const Divider(height: 30.0, thickness: 1.0), // Divider


                        const SizedBox(width: 8.0),
                        Text('Category: $category',
                          style:  TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),


                    const Divider(height: 30.0, thickness: 1.0), // Divider
                    // Book Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const SizedBox(height: 8.0), // Add space
                    Text(
                      description,
                      style:  TextStyle(
                        fontSize: 18.0,
                        color: Colors.blue[800],
                      ),
                    ),
                    const Divider(height: 30.0, thickness: 1.0),

                    if (isSeller && Csellerid == sellerId) ...[
                      Container(
                        width: double.infinity,
                        child: ProfileButton(
                          text: 'Update',
                          textColor: Colors.white,
                          onPressed: _updatebook,
                        ),
                      ),
                    ] else if (buyer == null || buyer.isEmpty) ...[
                      Container(
                        width: double.infinity,
                        child: ProfileButton(
                          text: 'Buy Now',
                          textColor: Colors.white,
                          onPressed: _buynow,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16.0),
                    const Text(
                      'Seller',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SellerCard(
                      username: username,
                      sellerid: sellerId,
                      collegeName: collegeName,
                      photo: sellerphoto,
                    ),
                    ],


                ),
              ) ,
            ],
          ),
        ),
      ),
    );
  }

}
