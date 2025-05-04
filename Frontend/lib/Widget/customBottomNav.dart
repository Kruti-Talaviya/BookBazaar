import 'package:bookbazaar/pages/UAccount.dart';
import 'package:flutter/material.dart';
import 'package:bookbazaar/pages/home.dart';
import 'package:bookbazaar/pages/SearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/SAccountPage.dart';
import '../pages/sellerSearch.dart'; // For managing seller status


class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late int _currentIndex;
  bool _isSeller = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchPage(),
    const sellerSearchPage(),
    const UAccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _checkIfSeller();
  }

  Future<void> _checkIfSeller() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSeller = prefs.getBool('isSeller') ?? false;
    });
  }

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        _screens[3] = _isSeller ? const SAccountPage() : const UAccountPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Track the selected index
        selectedItemColor: const Color(0xFF004aad),
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.blue[600],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Sellers'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        onTap: _onNavBarTapped, // Handle navigation tap
      ),
    );
  }
}

