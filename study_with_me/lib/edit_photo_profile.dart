import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/usermanager.dart';

class EditPhotoProfilePage extends StatefulWidget {
  const EditPhotoProfilePage({Key? key}) : super(key: key);

  @override
  State<EditPhotoProfilePage> createState() => _EditPhotoProfilePageState();
}

class _EditPhotoProfilePageState extends State<EditPhotoProfilePage> {
  List<Map<String, dynamic>> unlockedAvatars = [];
  late int selected_avatarID;

  @override
  void initState() {
    super.initState();
    fetchUnlockedAvatars();
  }

  Future<void> fetchUnlockedAvatars() async {
    final url = Uri.parse(
        '${config.localhost}/my_avatars?user_id=${UserManager.loggedInUserId}');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> avatars = jsonDecode(response.body);
        final List<Map<String, dynamic>> updatedAvatars =
            avatars.map((dynamic avatar) {
          return <String, dynamic>{
            ...avatar,
            'isUnlocked': true, // Assuming all avatars fetched are unlocked
          };
        }).toList();

        setState(() {
          unlockedAvatars = updatedAvatars;
        });
      } else {
        throw Exception('Failed to fetch unlocked avatars');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> selectAvatar() async {
    final url = Uri.parse(
        '${config.localhost}/select_avatar?avatar_id=${selected_avatarID}&user_id=${UserManager.loggedInUserId}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo profile selected successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to select photo profile'),
            backgroundColor: Colors.red,
          ),
        );
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
          'Edit Photo Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: unlockedAvatars.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: unlockedAvatars.length,
              itemBuilder: (context, index) {
                final avatar = unlockedAvatars[index];
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
                        SizedBox(width: 55),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              selected_avatarID = avatar['id'];
                            });
                            selectAvatar();
                          },
                          child: const Text('Select'),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
