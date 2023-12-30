// ignore_for_file: unused_element, non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/config.dart';
import 'package:study_with_me/login.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  TextEditingController FullNameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController UniversityController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();

  // Function to split full name into first name and last name
  Map<String, String> splitFullName(String fullName) {
    List<String> names = fullName.split(' ');

    String firstName = names.length > 0 ? names[0] : '';
    String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  Future<void> signup(String fullName, String email, String username,
      String password, String uni, String phone) async {
    final url = Uri.parse('${config.localhost}/signup');
    Map<String, String> names = splitFullName(fullName);

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
      'university': uni,
      'email': email,
      'first_name': names['first_name'],
      'last_name': names['last_name'],
      'phone': phone
    };

    String data = jsonEncode(requestBody);

    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // Login failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("SignUp Failed"),
            content: const Text(
                "You are trying to sign up with invalid information"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: FullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            TextField(
              controller: EmailController,
              decoration: const InputDecoration(
                labelText: 'email',
              ),
            ),
            TextField(
              controller: UsernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: PasswordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: ConfirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            TextField(
              controller: UniversityController,
              decoration: const InputDecoration(
                labelText: 'University/School',
              ),
            ),
            TextField(
              controller: PhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signup(
                  FullNameController.text,
                  EmailController.text,
                  UsernameController.text,
                  PasswordController.text,
                  UniversityController.text,
                  PhoneController.text,
                );
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(
                          100, 30), // Adjust the width and height as needed
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
