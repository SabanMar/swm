import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'get_started.dart';
import 'usermanager.dart';
import 'change_password.dart';

class Profile extends StatefulWidget {
  final int userID;

  const Profile({Key? key, required this.userID}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {};
  late Future<Map<String, dynamic>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final url = Uri.parse(
        '${config.localhost}/get_user_data?user_id=${UserManager.loggedInUserId}');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (error) {
      // Handle errors here
      print('Error: $error');
      throw error;
    }
  }

  void logout(int userId) {
    UserManager.loggedInUserId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFFDDEBDD)),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            userData = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 366.42,
                    width: 287.89,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${userData['first_name']}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${userData['last_name']}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${userData['username']}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Studies at: ${userData['university']}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${userData['bio']}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Log out') {
                        logout(UserManager.loggedInUserId ?? 0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GetStarted()));
                      }
                      else if (value == 'Change Password') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage()));
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'Privacy-Policy',
                        child: Text('Privacy-Policy'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Change Password',
                        child: Text('Change Password'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Forgot Password',
                        child: Text('Forgot Password'),
                      ),
                      PopupMenuItem<String>(
                        value: 'Log out',
                        child: Text('Log out'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
