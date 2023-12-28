import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        'http://10.0.2.2:5000/get_session_details?session_id=${widget.sessionID}');

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
    final url = Uri.parse('http://10.0.2.2:5000/join_session');

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
                        "${UserManager.username} you are the host!",
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
                          child: Center(
                            child: Text(
                              sessionData['member${i}_id'] != null
                                  ? 'Member ${i}: ${sessionData['member${i}_id']}, Member name: ${sessionData['member${i}_username']}'
                                  : 'Empty Member $i',
                              textAlign: TextAlign.center,
                            ),
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