// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/session_details_member.dart';

class AllSessionsTest extends StatefulWidget {
  final String subject;
  final String location;
  final DateTime? startTime;
  final DateTime? endTime;

  const AllSessionsTest({
    Key? key,
    required this.subject,
    required this.location,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  State<AllSessionsTest> createState() => _AllSessionsTestState();
}

class _AllSessionsTestState extends State<AllSessionsTest> {
  List<Map<String, dynamic>> sessions = [];
  List<String> avatarImages = [];
   @override
  void initState() {
    super.initState();
    fetchAllSessions(
      widget.subject,
      widget.location,
      widget.startTime,
      widget.endTime,
    );
  }

  Future<void> fetchAllSessions(String subject, String location, DateTime? start_time, DateTime? end_time) async {
    final url = Uri.parse('${config.localhost}/get_all_sessions');


  final Map<String, dynamic> requestBody = {
    'subject': subject,
    'location': location,
  };

  if (start_time != null) {
    requestBody['start_time'] = start_time.toIso8601String();
  }
  if (end_time != null) {
    requestBody['end_time'] = end_time.toIso8601String();
  }

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(requestBody),
  );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        sessions = List<Map<String, dynamic>>.from(responseData);
      });
    } else {
      print("No sessions");
    }
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

  String getSelectedAvatar(Map<String, dynamic> sessionData) {
    String? hostAvatar =
        sessionData['host_avatar']; // the file name in database
    for (String avatarImage in avatarImages) {
      if (hostAvatar != '1' && avatarImage.contains(hostAvatar!)) {
        return avatarImage; // Return the matched avatar
      }
    }
    return 'assets/images/avatars/Frame 1.png'; // Default avatar
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFDDEBDD),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < sessions.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailsUser(
                          sessionID: sessions[i]['id'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                        backgroundImage:
                            AssetImage(getSelectedAvatar(sessions[i])),
                        radius: 25,
                      ),
                          Column(
                            children: [
                              Text("Location:" + sessions[i]['location']),
                              Text("Subject:" + sessions[i]['subject']),
                            ],
                          ),
                          Icon(
                            Icons.menu_book,
                            size: 50,
                          )
                        ],
                      )),
                ),
            ],
          ),
        ));
  }
}


