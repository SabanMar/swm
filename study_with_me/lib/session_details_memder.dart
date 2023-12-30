import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_with_me/config.dart';
import 'usermanager.dart';
import 'package:intl/intl.dart';

class SessionDetailsUser extends StatefulWidget {
  final int sessionID;

  const SessionDetailsUser({Key? key, required this.sessionID})
      : super(key: key);

  @override
  State<SessionDetailsUser> createState() => _SessionDetailsUserState();
}

class _SessionDetailsUserState extends State<SessionDetailsUser> {
  Map<String, dynamic> sessionData = {};
  late Timer _timer;
  late Future<Map<String, dynamic>> _sessionDataFuture;

  @override
  void initState() {
    super.initState();
    _sessionDataFuture = fetchSessionData();
    _checkPermissions();
    // Set up a periodic timer to refresh the session data every 10 seconds
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        _sessionDataFuture = fetchSessionData();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchSessionData() async {
    final url = Uri.parse(
        '${config.localhost}/get_session_details?session_id=${widget.sessionID}');

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
        throw Exception('Failed to fetch session data');
      }
    } catch (error) {
      // Handle errors here
      print('Error: $error');
      throw error;
    }
  }

  void joinSession(String sessionID, String user_id) async {
    final url = Uri.parse('http://127.0.0.1:5000/join_session');

    final Map<String, dynamic> requestData = {
      "session_id": sessionID,
      "member_id": user_id
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session joined successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join session')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  DateTime parseDateString(String dateString) {
    DateFormat format = DateFormat("E, d MMM yyyy HH:mm:ss 'GMT'");
    return format.parse(dateString);
  }

  bool canMakeCalls = false; // Flag to determine if calls are allowed

Future<void> _checkPermissions() async {
  var status = await Permission.phone.status;
  if (!status.isGranted) {
    status = await Permission.phone.request();
    if (status.isGranted) {
      setState(() {
        canMakeCalls = true;
      });
    } else {
      // Handle denied permissions here
      setState(() {
        canMakeCalls = false;
      });
    }
  } else {
    setState(() {
      canMakeCalls = true;
    });
  }
}

  void _makeCall(String phoneNumber) async {
    await _checkPermissions();
    if (canMakeCalls) {
      if (await canLaunch('tel:$phoneNumber')) {
        await launch('tel:$phoneNumber');
      } else {
        print('Could not launch $phoneNumber');
      }
    } else {
      print('Phone call permission not granted.');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    String formattedStartTime = '';
    String formattedEndTime = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _sessionDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            }

            Map<String, dynamic> sessionData = snapshot.data!;
            // Format date and times after fetching data
            formattedDate = DateFormat.yMMMd()
                .format(parseDateString(sessionData['start_time']));
            formattedStartTime = DateFormat.Hm()
                .format(parseDateString(sessionData['start_time']));
            formattedEndTime = DateFormat.Hm()
                .format(parseDateString(sessionData['end_time']));

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Your host",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Location:"),
                            Text("Subject:"),
                            Text("Date:"),
                            Text("Start time:"),
                            Text("End time:")
                          ],
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(sessionData['location']),
                            Text(sessionData['subject']),
                            Text(formattedDate),
                            Text(formattedStartTime),
                            Text(formattedEndTime),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Members of the session(${sessionData['current_members']}/${sessionData['max_members']})",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 1; i < sessionData['max_members']; i++)
                        Container(
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
                              Expanded(
                                child: Text(
                                  sessionData['member${i}_id'] != null
                                      ? 'Member ${i}: ${sessionData['member${i}_id']}, Member name: ${sessionData['member${i}_username']}'
                                      : 'Empty Member $i',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.phone),
                                onPressed: () {
                                  // Implement the call functionality here for member i
                                  String phoneNumber =
                                      sessionData['member${i}_phone'];
                                  _makeCall(phoneNumber);
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => joinSession(widget.sessionID.toString(),
                        UserManager.loggedInUserId.toString()),
                    child: Text(
                      "Join",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
