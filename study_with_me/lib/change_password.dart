import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() =>  _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  Future<void> changePassword() async  {
   final url = Uri.parse('${config.localhost}/change_password');

      final Map<String, dynamic> data = {
      'user_id': UserManager.loggedInUserId, // Replace with the user's ID
      'old_password': oldPasswordController.text,
      'new_password': newPasswordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Password changed successfully!');
      }
      else {
        print('Failed to change password.');
      }
    }
    catch (error) {
      print('Error: $error');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: const Color(0xFFDDEBDD),
      ),
       body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Old Password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: confirmNewPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text ==
                    confirmNewPasswordController.text) {
                  changePassword();
                } else {
                  // Show an error message if passwords don't match
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Passwords do not match.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}