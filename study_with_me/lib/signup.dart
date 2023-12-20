// ignore_for_file: unused_element, non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

    String firstName = names.isNotEmpty ? names[0] : '';
    String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return {
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  Future<void> signup(String fullName, String email, String username,
      String password, String uni, String phone) async {
    final url = Uri.parse('http://127.0.0.1:5000/signup');
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("SignUp Success"),
            content: const Text("Press ok to login"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
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
        backgroundColor: const Color(0xFFDDEBDD),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Hero(
                    tag: 'Girl',
                    child: Image.asset(
                      'assets/images/registration.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                ),
                TextFormField(
                  controller: FullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                    controller: EmailController,
                    decoration: const InputDecoration(
                      labelText: 'email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: UsernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Username';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                  controller: PasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                TextFormField(
                  controller: ConfirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                ),
                TextFormField(
                    controller: UniversityController,
                    decoration: const InputDecoration(
                      labelText: 'University/School',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your University/School';
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: PhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signup(
                        FullNameController.text,
                        EmailController.text,
                        UsernameController.text,
                        PasswordController.text,
                        UniversityController.text,
                        PhoneController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(618264),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
        ),
      ),
    );
  }
}
