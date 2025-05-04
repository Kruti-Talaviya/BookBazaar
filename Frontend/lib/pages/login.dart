import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bookbazaar/Widget/toast.dart';
import 'package:bookbazaar/config.dart';
import 'package:bookbazaar/Widget/elevated_Button.dart';
import 'package:bookbazaar/Widget/textFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _login() async {

      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        try {
          var userBody = {
            "email": emailController.text,
            "password": passwordController.text
          };

          var response = await http.post(Uri.parse(loginUrl),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(userBody));

          var jsonResponse = jsonDecode(response.body);

          if (jsonResponse['status'])
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('Cusername', jsonResponse['username']);
            await prefs.setBool('isSeller', jsonResponse['isSeller']);
            await prefs.setString('CUserid', jsonResponse['id']);
            if(jsonResponse['isSeller']){
              await prefs.setString('CSellerid', jsonResponse['sellerId']);
            }


            ToastUtils.showToast(jsonResponse['message'],Colors.green, Colors.white);
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacementNamed(context,'/nav');

          } else {
            ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
          }
        } catch (e) {
          ToastUtils.showToast('Network error: $e', Colors.red, Colors.white);
          print('Network error: $e');
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004aad),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo1.png',
              height: 150.0,
            ),

          ],
        ),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004aad),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                CustomTextFormField(
                  hintText: "Type your email",
                  prefixIcon: Icons.email,
                  controller: emailController,
                ),

                const SizedBox(height: 20.0),

                CustomTextFormField(
                  hintText: "Type your password",
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 30.0),

                CustomElevatedButton(
                    text: 'Log In',
                    textColor: Colors.white,
                    onPressed:_login

                ),
                const SizedBox(height: 20.0),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/sign_up');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF004aad),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
