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
import '../Widget/customBottomNav.dart';
import 'SAccountPage.dart';
import 'login.dart';


class AddbookPage extends StatefulWidget {
  const AddbookPage({Key? key}) : super(key: key);

  @override
  State<AddbookPage> createState() => _AddbookPageState();
}

class _AddbookPageState extends State<AddbookPage> {
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();//description
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String? imageUrl;
  String CSellerid='';

  @override
  void initState() {
    super.initState();
  }
  void _onImagePicked(String? pickedImageUrl) {
    setState(() {
      imageUrl = pickedImageUrl;
    });
  }
  void _addbook() async {
    if (priceController.text.isNotEmpty && authorController.text.isNotEmpty&&
        titleController.text.isNotEmpty && descriptionController.text.isNotEmpty&&
        categoryController.text.isNotEmpty &&
        imageUrl != null) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
         CSellerid = prefs.getString('CSellerid')!; // Fetch UserId from SharedPreferences

        var uri = Uri.parse(bookUrl);  // Your API endpoint

        var request = http.MultipartRequest('POST', uri);
        request.fields['title'] =titleController.text;
        request.fields['author'] = authorController.text;
        request.fields['price'] = priceController.text;
        request.fields['category'] = categoryController.text;
        request.fields['description'] = descriptionController.text;
        request.fields['sellerId'] = CSellerid ?? '';


        if (imageUrl != null) {
          var mimeType = lookupMimeType(imageUrl!)?.split('/');
          request.files.add(await http.MultipartFile.fromPath(
            'photo',  // This should match your server's field name
            imageUrl!,
            contentType: MediaType(mimeType![0], mimeType[1]),
          ));
        }

        var response = await request.send();
        print(response);
        if (response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var jsonResponse = jsonDecode(responseData);
          if (jsonResponse['status']) {
            ToastUtils.showToast(jsonResponse['message'], Colors.green, Colors.white);
            await Future.delayed(const Duration(seconds: 1));
            // Navigator.pushReplacementNamed(
            //     context,
            //     '/nav',
            //     arguments: {'initialIndex': 3},);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
            );
          } else {
            ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
          }
        } else {
          ToastUtils.showToast('Failed to add book', Colors.red, Colors.white);
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
        title: 'Add Book',
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
                hintText: "Title",
                controller: titleController,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                hintText: "Author",

                controller: authorController,
              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                hintText: "Price",
                controller: priceController,
              ),
              const SizedBox(height: 30.0),
              CustomTextFormField(
                hintText: "Category",
                controller: categoryController,
              ),
              const SizedBox(height: 30.0),
              CustomTextFormField(
                hintText: "Description",
                controller: descriptionController,
              ),
              const SizedBox(height: 30.0),
              CustomElevatedButton(
                text: 'Add',
                textColor: Colors.white,
                onPressed: _addbook, // Call the profile creation method
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
