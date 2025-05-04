// import 'package:flutter/material.dart';
//
// import '../pages/BookDetailPage.dart';
//
// class Sellercard extends StatelessWidget {
//   final String seller;
//   final String username;
//   final String collegeName;
//   final String sellerId;
//
//   final String id; // Add the id field
//
//   const Sellercard({
//
//     required this.seller,
//     required this.username,
//     required this.collegeName,
//     required this.sellerId, // Make the id a required field
//     super.key
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BookDetailPage(
//               id: id, // Pass the id to the detailed page
//
//             ),
//           ),
//         );
//       },
//       child: Container(
//
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           elevation: 5.0,
//           color: Colors.white,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0,
//                     color: Color(0xFF004aad),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   price,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.0,
//                     color: Color(0xFF004aad),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   sellerName,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../pages/SellerDetailsPage.dart';

class SellerCard extends StatelessWidget {
  final String username;

  final String collegeName;
  final String photo;
  final String sellerid;

  const SellerCard({
    required this.username,

    required this.collegeName,
    required this.photo,
    required this.sellerid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SellerDetailsPage(
            id: sellerid,

          ),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // User image
            ClipOval(
              child: Image.network(
                photo,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16.0),

            // User details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $username',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Color(0xFF004aad), // Your preferred blue color
                  ),
                ),

                Text(
                  'College Name: $collegeName',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue[800],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}

