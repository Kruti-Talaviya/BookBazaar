import 'package:bookbazaar/pages/AddBook.dart';
import 'package:bookbazaar/pages/SAccountPage.dart';
import 'package:bookbazaar/pages/SupdateProfile.dart';
import 'package:bookbazaar/pages/buynow.dart';
import 'package:bookbazaar/pages/sellAndearn.dart';
import 'package:bookbazaar/pages/viewOrder.dart';
import 'package:bookbazaar/pages/viewinsights.dart';
import 'package:flutter/material.dart';
import 'package:bookbazaar/pages/Loading.dart';
import 'package:bookbazaar/pages/signup.dart';
import 'package:bookbazaar/pages/login.dart';
import 'package:bookbazaar/pages/sellAndearn.dart';
import 'package:bookbazaar/Widget/customBottomNav.dart';
void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes:{
         '/': (context)=> const Loading(),
         '/login': (context) => const LoginPage(),
         '/sign_up': (context) => const Signup(),
         '/nav': (context) => const HomePage(),
        '/createseller':(context) => const CreateSellerPage(),
        '/updateseller':(context) => const UpdateSellerPage(),
        '/addbook':(context) => const AddbookPage(),
        '/profile':(context) => const SAccountPage(),
        '/buynow':(context) => const BuybookPage(),
        '/vieworder':(context) => const Vieworder(),
        '/ViewInsightsPage':(context) => const ViewInsightsPage(),


      },
     onGenerateRoute: (settings) {
      // Handle routes with arguments here
      if (settings.name == '/nav') {
        final args = settings.arguments as Map<String, dynamic>?;

        // Retrieve the initialIndex from the arguments if passed, otherwise default to 0
        final initialIndex = args?['initialIndex'] ?? 0;

        // Pass the initialIndex to HomePage
        return MaterialPageRoute(
          builder: (context) => HomePage(initialIndex: initialIndex),
        );
      }
      // Return null if the route is not handled here
      return null;
    },

  ));
}



