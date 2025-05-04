import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;  // To get the file name
import 'package:mime/mime.dart';  // To get mime type
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bookbazaar/Widget/toast.dart';
import 'package:bookbazaar/config.dart';
import 'package:bookbazaar/Widget/elevated_Button.dart';
import 'package:bookbazaar/Widget/textFormField.dart';
import 'package:bookbazaar/Widget/SettingButtons.dart';
import 'package:bookbazaar/Widget/Gen_Appbar.dart';
import '../Widget/CircularAvatar.dart';
import 'login.dart';


class CreateSellerPage extends StatefulWidget {
  const CreateSellerPage({Key? key}) : super(key: key);

  @override
  State<CreateSellerPage> createState() => _CreateSellerPageState();
}

class _CreateSellerPageState extends State<CreateSellerPage> {
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

  void _createSellerProfile() async {
    if (phoneController.text.isNotEmpty &&
        clgController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        imageUrl != null) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('CUserid'); // Fetch UserId from SharedPreferences

        var uri = Uri.parse(sellerUrl);  // Your API endpoint

        var request = http.MultipartRequest('POST', uri);
        request.fields['userId'] = userId ?? '';
        request.fields['phoneNumber'] = phoneController.text;
        request.fields['collegeName'] = clgController.text;
        request.fields['city'] = cityController.text;

        // Attach the image file to the request
        if (imageUrl != null) {
          var mimeType = lookupMimeType(imageUrl!)?.split('/');
          request.files.add(await http.MultipartFile.fromPath(
            'photo',  // This should match your server's field name
            imageUrl!,
            contentType: MediaType(mimeType![0], mimeType[1]),
          ));
        }

        var response = await request.send();

        if (response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = jsonDecode(responseData);
          if (jsonResponse['status']) {
            ToastUtils.showToast(jsonResponse['message'], Colors.green, Colors.white);
            await Future.delayed(const Duration(seconds: 1));
            // Navigator.pushReplacementNamed(context, '/login');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
            );

          } else {
            ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
          }
        } else {
          ToastUtils.showToast('Failed to create seller profile', Colors.red, Colors.white);
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
        title: 'Create Seller Profile',
        showBackArrow: true,
        showTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 30.0),
              Center(
                child: UpdateAvatar(
                  radius: 60.0,
                  enableImagePicking: true,
                  onImagePicked: _onImagePicked, // Pass the callback for image picking
                ),
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
                text: 'Create',
                textColor: Colors.white,
                onPressed: _createSellerProfile, // Call the profile creation method
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
