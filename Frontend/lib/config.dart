// const url = 'http://192.168.25.179:3000/';
// const url = 'http://192.168.1.45:3000/';
// const url = 'http://192.168.219.179:3000/';

const url = 'http://192.168.135.179:3000/';
// const url = 'http://192.168.1.25:3000/';


const signupUrl = url + 'signup';
const loginUrl = url + 'login';
const sellerUrl = url + 'seller';
const backendUrl = url + 'Backend';
const bookUrl = url + 'book';
const purchaseUrl = bookUrl +'/purchase';
const buyerUrl = bookUrl +'/buyer';














// Categories section
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.3),
//           spreadRadius: 2,
//           blurRadius: 5,
//         ),
//       ],
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 10.0),
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           CategoryButton(
//             label: 'B.Tech',
//             isSelected: selectedCategory == 'B.Tech',
//             onTap: () => _changeCategory('B.Tech'),
//           ),
//           CategoryButton(
//             label: 'M.Tech',
//             isSelected: selectedCategory == 'M.Tech',
//             onTap: () => _changeCategory('M.Tech'),
//           ),
//
//           CategoryButton(
//             label: 'MCA',
//             isSelected: selectedCategory == 'MCA',
//             onTap: () => _changeCategory('MCA'),
//           ),
//           CategoryButton(
//             label: 'BCA',
//             isSelected: selectedCategory == 'BCA',
//             onTap: () => _changeCategory('BCA'),
//           ),
//           // Add more categories as needed
//         ],
//       ),
//     ),
//   ),
// ),