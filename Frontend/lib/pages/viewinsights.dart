// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// import '../Widget/Gen_Appbar.dart';
// import '../cards/BookCard.dart';
// import '../config.dart'; // Assuming this card widget displays each book
//
// class ViewInsightsPage extends StatefulWidget {
//
//   const ViewInsightsPage({Key? key}): super(key: key);
//
//   @override
//   _ViewInsightsPageState createState() => _ViewInsightsPageState();
// }
//
// class _ViewInsightsPageState extends State<ViewInsightsPage> {
//   String sellerId = '';
//   String selectedCategory = 'All';
//   List<Map<String, dynamic>> books = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadsellerid();
//     // Fetch sold books initially for 'All' category
//   }
//   void _loadsellerid() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       sellerId = prefs.getString('CSellerid') ?? 'User';
//     });
//
//     if (sellerId != 'User') {
//       fetchSoldBooks();
//     }
//   }
//   // Fetch sold books based on selected category
//   Future<void> fetchSoldBooks() async {
//     final Uri url1 = Uri.parse('$bookUrl/seller/$sellerId'); // API endpoint
//     try {
//       var response = await http.get(url1);
//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(response.body);
//         setState(() {
//           if (jsonResponse['books'] is List) {
//             books = List<Map<String, dynamic>>.from(jsonResponse['books']);
//             books = books.map((book) {
//               if (book['photo'] is String) {
//                 String photoUrl = book['photo'].replaceAll('\\', '/');
//                 book['photo'] = '$url' + '$photoUrl';
//               }
//               return book;
//             }).toList();
//             print(books);
//           } else {
//             books = [];
//           }
//         });
//       } else {
//         print("Error: ${response.statusCode}");
//       }
//     } catch (error) {
//       print("Failed to load books: $error");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const SimpleAppBar(
//         title: 'Insights',
//         showBackArrow: true,
//         showTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Category Dropdown
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: DropdownButton<String>(
//               value: selectedCategory,
//               items: ['All', 'Notes', 'BTech', 'MTech']
//                   .map((category) => DropdownMenuItem<String>(
//                 value: category,
//                 child: Text(category),
//               ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedCategory = value!;
//                   fetchSoldBooks(); // Fetch books based on the new category
//                 });
//               },
//             ),
//           ),
//
//           // Display sold books in a grid view
//           Expanded(
//             child: books.isNotEmpty
//                 ? GridView.builder(
//               padding: const EdgeInsets.all(10.0),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10.0,
//                 mainAxisSpacing: 10.0,
//                 childAspectRatio: 2 / 3,
//               ),
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 final book = books[index];
//                 return BookCard(
//                   imageUrl: book['photo'] as String? ?? 'default_image.png',
//                   title: book['title']?.toString() ?? 'No Title',
//                   price: book['price']?.toString() ?? 'Unknown Price',
//                   sellerName: 'You', // Since it's the seller's insights
//                   category: book['category']?.toString() ?? 'Unknown',
//                   id: book['_id']?.toString() ?? '',
//                   sellerId: sellerId,
//                 );
//               },
//             )
//                 : Center(
//               child: Text('No sold books found for this category'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Widget/Gen_Appbar.dart';
import '../cards/BookCard.dart';
import '../config.dart'; // Assuming this card widget displays each book

class ViewInsightsPage extends StatefulWidget {
  const ViewInsightsPage({Key? key}) : super(key: key);

  @override
  _ViewInsightsPageState createState() => _ViewInsightsPageState();
}

class _ViewInsightsPageState extends State<ViewInsightsPage> {
  String sellerId = '';
  String selectedCategory = 'All';
  List<Map<String, dynamic>> books = [];

  List<String> categories = ['All', 'Notes', 'BTech', 'MTech','BSA'];
  // List<bool> selectedCategories = [true, false, false, false,false]; // Toggle button states
  String selectedCategories = 'All';
  @override
  void initState() {
    super.initState();
    _loadSellerId();
  }

  void _loadSellerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sellerId = prefs.getString('CSellerid') ?? 'User';
    });

    if (sellerId != 'User') {
      fetchSoldBooks();
    }
  }

  // Fetch sold books based on selected category
  Future<void> fetchSoldBooks() async {
    final Uri url1 = Uri.parse('$bookUrl/seller/$sellerId'); // API endpoint
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
  void _changeCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        fetchSoldBooks(); // Fetch all books if 'All' is selected
      } else {
        books = books.where((book) {
          final bookCategory = book['category']?.toString().toLowerCase() ?? '';
          return bookCategory == category.toLowerCase();
        }).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Insights',
        showBackArrow: true,
        showTitle: true,
      ),
      body: Column(
        children: [
          // Categories section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryButton(
                      label: 'All',
                      isSelected: selectedCategory == 'All',
                      onTap: () => _changeCategory('All'),
                    ),
                    CategoryButton(
                      label: 'BTech',
                      isSelected: selectedCategory == 'BTech',
                      onTap: () => _changeCategory('BTech'),
                    ),
                    CategoryButton(
                      label: 'MTech',
                      isSelected: selectedCategory == 'MTech',
                      onTap: () => _changeCategory('MTech'),
                    ),
                    CategoryButton(
                      label: 'MCA',
                      isSelected: selectedCategory == 'MCA',
                      onTap: () => _changeCategory('MCA'),
                    ),
                    CategoryButton(
                      label: 'BCA',
                      isSelected: selectedCategory == 'BCA',
                      onTap: () => _changeCategory('BCA'),
                    ),
                    // Add more categories as needed
                  ],
                ),
              ),
            ),
          ),

          // Display sold books in a grid view
          Expanded(
            child: books.isNotEmpty
                ? GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  imageUrl: book['photo'] as String? ?? 'default_image.png',
                  title: book['title']?.toString() ?? 'No Title',
                  price: book['price']?.toString() ?? 'Unknown Price',
                  sellerName: 'You', // Since it's the seller's insights
                  category: book['category']?.toString() ?? 'Unknown',
                  id: book['_id']?.toString() ?? '',
                  sellerId: sellerId,
                );
              },
            )
                : const Center(
              child: Text('No sold books found for this category'),
            ),
          ),
        ],
      ),
    );
  }
}

// The CategoryButton widget definition
class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}