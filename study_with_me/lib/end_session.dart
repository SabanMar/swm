import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:study_with_me/homepage.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;

class EndSession extends StatefulWidget {
  final int sessionID;
  final int elapsedTime;
  final int buttonPressCount;

  final Map<String, dynamic> sessionData;

  const EndSession({
    Key? key,
    required this.sessionID,
    required this.sessionData,
    required this.elapsedTime,
    required this.buttonPressCount,
  }) : super(key: key);

  @override
  State<EndSession> createState() => _EndSessionState();
}

class _EndSessionState extends State<EndSession> {
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  Future<int?> ImageCount(int sessionID) async {
    final url = Uri.parse(
        '${config.localhost}/count_images?session_id=${widget.sessionID}');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['COUNT(*)'];
      } else {
        throw Exception('Failed to fetch session data');
      }
    } catch (error) {
      // Handle errors here
      print('Error: $error');
      throw error;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Congratulations',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Container(
              width: 400,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                      'You studied ${widget.sessionData['subject']} ${formatTime(widget.elapsedTime)} minutes'),
                  Text(
                      'And you took ${(widget.buttonPressCount ~/ 2 + widget.buttonPressCount % 2)} breaks'),
                  FutureBuilder<int?>(
                    future: ImageCount(widget.sessionID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error loading image count');
                      } else {
                        return Text('Images uploaded: ${snapshot.data ?? 0}');
                      }
                    },
                  ),
                  Text('You earned --- coins'),
                ],
              ))),
          SizedBox(height: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Text('Leave'),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
