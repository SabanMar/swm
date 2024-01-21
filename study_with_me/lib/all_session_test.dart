import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Map<String, dynamic> hostData = {};
  @override
  void initState() {
    super.initState();
    avatarImages = avatarList();
    fetchAllSessions(
      widget.subject,
      widget.location,
      widget.startTime,
      widget.endTime,
    );
  }

  Future<void> fetchAllSessions(String subject, String location,
      DateTime? start_time, DateTime? end_time) async {
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
      for (int i = 0; i < responseData.length; i++) {
        // Fetch host details for each session
        await fetchHostDetails(responseData[i]['host_id'], i);
      }
    } else {
      print("No sessions");
    }
  }

  Future<void> fetchHostDetails(int hostId, int sessionIndex) async {
    final url = Uri.parse('${config.localhost}/get_user_data?user_id=$hostId');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      hostData = jsonDecode(response.body);

      // Check if the sessionIndex is within the bounds of the sessions list
      if (sessionIndex >= 0 && sessionIndex < sessions.length) {
        setState(() {
          sessions[sessionIndex]['host_username'] = hostData['username'];
          sessions[sessionIndex]['host_university'] = hostData['university'];
          sessions[sessionIndex]['host_avatar'] = hostData['avatar'];
        });
      } else {
        print("Invalid sessionIndex: $sessionIndex");
      }
    } else {
      print("Failed to fetch host details for host ID: $hostId");
    }
  }

  DateTime parseDateString(String dateString) {
    DateFormat format = DateFormat("E, d MMM yyyy HH:mm:ss 'GMT'");
    return format.parse(dateString);
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
      if (hostAvatar != null && avatarImage.contains(hostAvatar)) {
        return avatarImage; // Return the matched avatar
      }
    }
    return 'assets/images/avatars/Frame 1.png'; // Default avatar
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onScaleUpdate: (ScaleUpdateDetails details) {
        // Check if two fingers are moving from left to right
        if (details.scale == 1 && details.rotation == 0) {
          if (details.horizontalScale > 1.0) {
            // Two fingers moving from left to right
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
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
                              radius: 35,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size:
                                          18.0, // Set the desired size of the icon
                                    ),
                                    Text("   " +
                                        DateFormat.yMMMd().format(parseDateString(
                                            sessions[i]['start_time'])) +
                                        " " +
                                        DateFormat.Hm().format(parseDateString(
                                            sessions[i]['start_time']))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.face,
                                      size:
                                          18.0, // Set the desired size of the icon
                                    ),
                                    Text("   " +
                                        sessions[i]['host_username'].toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size:
                                          18.0, // Set the desired size of the icon
                                    ),
                                    Text("   " + sessions[i]['location']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size:
                                          18.0, // Set the desired size of the icon
                                    ),
                                    Text("   " + sessions[i]['subject']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.groups,
                                      size:
                                          18.0, // Set the desired size of the icon
                                    ),
                                    Text("   " +
                                        sessions[i]['current_members']
                                            .toString() +
                                        "/" +
                                        sessions[i]['max_members'].toString()),
                                  ],
                                )
                              ],
                            ),
                            Image(
                              image: AssetImage('assets/images/book.png'),
                              width: 40.0, // Set width
                              height: 40.0, // Set height
                            ),
                          ],
                        )),
                  ),
              ],
            ),
          )),
    );
  }
}
