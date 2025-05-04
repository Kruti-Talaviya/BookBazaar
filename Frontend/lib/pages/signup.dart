import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:bookbazaar/Widget/toast.dart';
import 'package:bookbazaar/config.dart';
import 'package:bookbazaar/Widget/elevated_Button.dart';
import 'package:bookbazaar/Widget/textFormField.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formGlobalKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _submitForm() async {
    if (_formGlobalKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', usernameController.text);
      if (usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty){
        try{
          var userBody ={
            "username": usernameController.text,
            "email" : emailController.text,
            "password":  passwordController.text
          };
          var response = await http.post(Uri.parse(signupUrl),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(userBody));
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'])
          {
            ToastUtils.showToast(jsonResponse['message'], Colors.green, Colors.white);
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacementNamed(context, '/login');
          }
          else {
            ToastUtils.showToast(jsonResponse['message'], Colors.red, Colors.white);
          }
        }catch (e) {
          print('Network error: $e');
        }

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
            // const SizedBox(width: 10.0),

          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formGlobalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004aad),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),

              CustomTextFormField(
                hintText: 'Username',
                prefixIcon: Icons.person,
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              CustomTextFormField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                controller: emailController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              CustomTextFormField(
                hintText: 'Password',
                prefixIcon: Icons.lock,
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              CustomTextFormField(
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                controller: confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password is required';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30.0),

              CustomElevatedButton(
                text: 'Sign Up',
                textColor: Colors.white,
                onPressed:_submitForm

              ),
              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
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
    );
  }

}
