import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/usermanager.dart';

class AvailableAvatars extends StatefulWidget {
  const AvailableAvatars({Key? key}) : super(key: key);

  @override
  State<AvailableAvatars> createState() => _AvailableAvatarsState();
}

class _AvailableAvatarsState extends State<AvailableAvatars> {
  List<dynamic> avatars = [];
  dynamic unlock_avatar = [];

  @override
  void initState() {
    super.initState();
    fetchAvatars();
  }

  Future<void> fetchAvatars() async {
    final url = Uri.parse('${config.localhost}/available_avatars');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          avatars = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> unlockAvatar({required int avatarId}) async {
    final url = Uri.parse(
        '${config.localhost}/unlock_avatar?avatar_id=$avatarId&user_id=${UserManager.loggedInUserId}');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          unlock_avatar = jsonDecode(response.body);
        });
      } else if (response.statusCode == 400) {
        final errorMessage = jsonDecode(response.body)['message'];
        // Insufficient coins error (400)
        // Show a message to the user indicating insufficient coins
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(errorMessage ?? 'Not enough coins'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to unlock data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
        title: const Text(
          'Unlock your avatars',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: avatars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                final avatar = avatars[index];
                return ListTile(
                  title: Container(
                    height: 75,
                    width: 316,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    padding:
                        EdgeInsets.all(8.0), // Add padding around the container
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(avatar['file_name']),
                          radius: 30,
                        ),
                        SizedBox(
                            width:
                                25), // Adjust the width as needed for spacing between widgets
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/coin.png',
                              width: 22,
                              height: 22,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${avatar['cost']}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                                onPressed: () {
                                  int avatarID =
                                      avatar['id']; // Get the avatar ID
                                  unlockAvatar(avatarId: avatarID);
                                },
                                child: const Text('GET'))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
