import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bookbazaar/Widget/elevated_Button.dart';
import 'package:bookbazaar/Widget/textFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widget/Gen_Appbar.dart';
import '../Widget/toast.dart';
import '../config.dart';

class BuybookPage extends StatefulWidget {
  const BuybookPage({Key? key}) : super(key: key);

  @override
  State<BuybookPage> createState() => _BuybookPageState();
}

class _BuybookPageState extends State<BuybookPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController altMobileController = TextEditingController();
  String BookId='';
  String Cuserid= '';
  @override
  void initState() {
    super.initState();
  }
  Future<void> _getBookId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      BookId = prefs.getString('bookid') ?? '';
      Cuserid = prefs.getString('CUserid') ?? '';
    });
  }

  Future<void> _orderBook() async {
    await _getBookId();
    var userBody = {
      "buyerId": Cuserid,

    };
    final Uri url1 = Uri.parse('$purchaseUrl/$BookId');
    var response = await http.post(url1,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userBody));

    var jsonResponse = jsonDecode(response.body);
    if(response.statusCode == 200){
      ToastUtils.showToast(jsonResponse['message'] , Colors.green, Colors.white);
      Navigator.pushReplacementNamed(context,'/nav');
    } else {
      ToastUtils.showToast(jsonResponse['message'] , Colors.red, Colors.white);
    }
  }


  void _payNow() {

    print('Pay Now pressed');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        title: 'Buy Book',
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
              const SizedBox(height: 20.0),
              CustomTextFormField(
                hintText: "Mobile Number",
                controller: mobileController,

              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                hintText: "Alternative Mobile Number",
                controller: altMobileController,

              ),
              const SizedBox(height: 20.0),
              CustomTextFormField(
                hintText: "Address",
                controller: addressController,
                maxlines: 3,
              ),
              const SizedBox(height: 20.0),
              CustomElevatedButton(
                text: 'Pay Now',
                textColor: Colors.white,
                onPressed: _payNow,
              ),
              const SizedBox(height: 20.0),
              CustomElevatedButton(
                text: 'Order Book',
                textColor: Colors.white,
                onPressed: _orderBook,
              ),
            ],
          ),
        ),
      ),
    );
  }



}
