import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/available_avatars.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/edit_photo_profile.dart';
import 'package:study_with_me/history.dart';
import 'package:study_with_me/homepage.dart';
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

  List<String> avatarImages = [];

  @override
  void initState() {
    super.initState();
    _userDataFuture = fetchUserData();
    avatarImages = avatarList();
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

  List<String> avatarList() {
    List<String> images = [];
    for (int i = 1; i <= 40; i++) {
      String imagePath = 'assets/images/avatars/Frame 1 ($i).png';
      images.add(imagePath);
    }
    images.add('assets/images/avatars/Frame 1.png');
    return images;
  }

  String getSelectedAvatar(Map<String, dynamic> userData) {
    String? userAvatar = userData['avatar']; // the file name in database
    for (String avatarImage in avatarImages) {
      if (userAvatar != null && avatarImage.contains(userAvatar)) {
        return avatarImage; // Return the matched avatar
      }
    }
    return 'assets/images/avatars/Frame 1.png'; // Default avatar
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
                    height: 466.42,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width: 5),
                                IconButton(
                                  icon: Icon(Icons.shopping_basket,
                                      color: Colors.green),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AvailableAvatars(),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 150),
                                Image.asset(
                                  'assets/images/coin.png',
                                  width: 22,
                                  height: 22,
                                ),
                                SizedBox(width: 5),
                                Text('${userData['coins']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(getSelectedAvatar(userData)),
                            radius: 50,
                          ),
                          SizedBox(height: 10),
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
                          Text(
                            '${userData['username']}',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, size: 18),
                              SizedBox(width: 5),
                              Text(
                                'Studies at: ${userData['university']}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              userData['bio'] == null
                                  ? ''
                                  : '${userData['bio']}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set your desired color
                            borderRadius: BorderRadius.circular(
                                6.0), // Set your desired border radius
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.archive_rounded),
                            iconSize: 30,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryPage(
                                        userId: UserManager.loggedInUserId
                                            .toString())),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            12.0), // Add padding/margin around the icon
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set your desired color
                            borderRadius: BorderRadius.circular(
                                6.0), // Set your desired border radius
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.home),
                            iconSize: 30,
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Set your desired color
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.settings),
                            iconSize: 30,
                            onSelected: (value) {
                              if (value == 'Log out') {
                                logout(UserManager.loggedInUserId ?? 0);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GetStarted()));
                              } else if (value == 'Change Password') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangePasswordPage()));
                              } else if (value == 'Edit photo profile') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditPhotoProfilePage()));
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'Change Password',
                                child: Text('Change Password'),
                              ),
                              PopupMenuItem<String>(
                                value: 'Log out',
                                child: Text('Log out'),
                              ),
                              PopupMenuItem<String>(
                                value: 'Edit photo profile',
                                child: Text('Edit photo profile'),
                              ),
                            ],
                          ),
                        ),
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
