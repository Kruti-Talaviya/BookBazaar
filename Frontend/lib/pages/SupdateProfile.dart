import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bookbazaar/Widget/toast.dart';
import 'package:bookbazaar/config.dart';
import 'package:bookbazaar/Widget/elevated_Button.dart';
import 'package:bookbazaar/Widget/textFormField.dart';
import 'package:bookbazaar/Widget/SettingButtons.dart';
import 'package:bookbazaar/Widget/Gen_Appbar.dart';
import '../Widget/CircularAvatar.dart';

class UpdateSellerPage extends StatefulWidget {
  const UpdateSellerPage({Key? key}) : super(key: key);

  @override
  State<UpdateSellerPage> createState() => _UpdateSellerPageState();
}

class _UpdateSellerPageState extends State<UpdateSellerPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController clgController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String? imageUrl;

  @override
  void initState() {
    super.initState();
  }

  // This method will be called when user picks an image
  void _onImagePicked(String? pickedImageUrl) {
    setState(() {
      imageUrl = pickedImageUrl;
    });
  }

  void _saveProfile() async {
    if (phoneController.text.isNotEmpty &&
        clgController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        imageUrl != null) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('Userid'); // Fetch UserId from SharedPreferences

        var userBody = {
          "userId": userId, // Pass the userId
          "phoneNumber": phoneController.text,
          "collegeName": clgController.text,
          "city": cityController.text,
          "photo": imageUrl, // Pass the image URL
        };

        var response = await http.post(Uri.parse(sellerUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(userBody));

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          // await prefs.setBool('isSeller', true); // Mark user as seller in SharedPreferences
          ToastUtils.showToast(jsonResponse['message'], Colors.green, Colors.white);
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
        }
      } catch (e) {
        ToastUtils.showToast('Network error: $e', Colors.red, Colors.white);
        print('Network error: $e');
      }
    } else {
      ToastUtils.showToast('All fields must be filled and an image must be selected', Colors.red, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Update Profile',
        showBackArrow: true,
        showTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Center(
                //   child: Text(
                //     'Create Seller Profile',
                //     style: TextStyle(
                //       fontSize: 24.0,
                //       fontWeight: FontWeight.bold,
                //       color: Color(0xFF004aad),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 30.0),
                UpdateAvatar(
                  radius: 70.0,
                  enableImagePicking: true,
                  onImagePicked: _onImagePicked, // Pass the callback for image picking
                ),
                const SizedBox(height: 30.0),
                CustomTextFormField(
                  hintText: "Phone Number",
                  prefixIcon: Icons.phone,
                  controller: phoneController,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  hintText: "College Name",
                  prefixIcon: Icons.school,
                  controller: clgController,
                ),
                const SizedBox(height: 20.0),
                CustomTextFormField(
                  hintText: "City",
                  prefixIcon: Icons.location_city,
                  controller: cityController,
                ),
                const SizedBox(height: 30.0),
                CustomElevatedButton(
                  text: 'Save',
                  textColor: Colors.white,
                  onPressed: _saveProfile, // Call the profile creation method
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
