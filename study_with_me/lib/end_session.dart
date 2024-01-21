import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/homepage.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;

class EndSession extends StatefulWidget {
  final int sessionID;
  final Map<String, dynamic> sessionData;
  final int elapsedTime;
  final int buttonPressCount;

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
  late Map<String, dynamic> _updatedSessionData;

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

  @override
  void initState() {
    super.initState();
    // Call fetchSessionData to get the updated session data
    fetchSessionData().then((data) {
      setState(() {
        _updatedSessionData = data;
      });
    });
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..scale(-1.0, 1.0, 1.0), // Mirroring horizontally
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/image1.png', // Replace this with the path to your image asset
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(width: 15),
              const Text(
                'Congratulations',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 146, 104, 158),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 15),
              Image.asset(
                'assets/images/image1.png', // Replace this with the path to your image asset
                width: 40, // Adjust the width as needed
                height: 40, // Adjust the height as needed
              ),
            ],
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
                  Text('You earned ${_updatedSessionData['coins']} coins'),
                ],
              ))),
          SizedBox(height: 200),
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Set your desired color
              borderRadius:
                  BorderRadius.circular(6.0), // Set your desired border radius
            ),
            child: IconButton(
              icon: const Icon(Icons.home),
              iconSize: 30,
              onPressed: () async {
                Navigator.push(
                    context,
                    // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ),
        ],
      )),
    );
  }
}
