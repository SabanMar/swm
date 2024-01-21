// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/image_display_page.dart';

class HistoryPage extends StatefulWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> sessionsHistory = [];
  List<Widget> images = [];
  @override
  void initState() {
    super.initState();
    fetchHistorySessions();
  }

  Future<void> fetchHistorySessions() async {
    final url = Uri.parse(
        '${config.localhost}/get_all_sessions_history?user_id=${widget.userId}');

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        sessionsHistory = List<Map<String, dynamic>>.from(responseData);
      });
    } else {
      print("No sessions");
    }
  }

  DateTime parseDateString(String dateString) {
    DateFormat format = DateFormat("E, d MMM yyyy HH:mm:ss 'GMT'");
    return format.parse(dateString);
  }

  int calculateSessionDuration(String startTime, String endTime) {
    DateTime startDateTime = parseDateString(startTime);
    DateTime endDateTime = parseDateString(endTime);

    Duration difference = endDateTime.difference(startDateTime);

    int minutes = difference.inMinutes;

    return minutes;
  }

  Future<void> getImages(int sessionID) async {
    try {
      final response = await http.get(
        Uri.parse('${config.localhost}/get_image?session_id=$sessionID'),
      );

      if (response.statusCode == 200) {
        // Assuming the response is in JSON format
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jsonData = jsonResponse['images'];
        for (var item in jsonData) {
          // Use the base64-encoded image data
          String imageBase64 = item['photo'];
          displayImage(imageBase64);
        }
      } else {
        print('Failed to get images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during image retrieval: $e');
    }
  }

  void displayImage(String imageBase64) {
    try {
      List<int> imageData = base64Decode(imageBase64);
      print('Image data length: ${imageData.length}');
      setState(() {
        images.add(Image.memory(Uint8List.fromList(imageData)));
      });
      print('Number of images: ${images.length}');
    } catch (e) {
      print('Error decoding image: $e');
    }
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
          backgroundColor: Color(0xFF618264),
          appBar: AppBar(
            backgroundColor: const Color(0xFFDDEBDD),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ARCHIVE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    )
                  ],
                ),
                for (int i = 0; i < sessionsHistory.length; i++)
                  GestureDetector(
                    onTap: () async {
                      // Call the function to get images
                      await getImages(sessionsHistory[i]['id']);
                      // Navigate to ImageDisplayPage with the list of images
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            // Clear the images list
                            List<Image> clearedImages = List.from(images);
                            images.clear();
                            return ImageDisplayPage(images: clearedImages);
                          },
                        ),
                      );
                    },
                    child: Container(
                        //padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Session #" + (i + 1).toString(),
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 68, 102, 70),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  sessionsHistory[i]['subject'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      sessionsHistory[i]['coins'].toString(),
                                      style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      'assets/images/coin.png',
                                      height: 15,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFDDEBDD),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/archive.png'),
                                      width: 40.0, // Set width
                                      height: 40.0, // Set height
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.watch_later_rounded,
                                            color: const Color(0xFF618264),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            DateFormat.Hm().format(
                                                    parseDateString(
                                                        sessionsHistory[i]
                                                            ['start_time'])) +
                                                "-" +
                                                DateFormat.Hm().format(
                                                    parseDateString(
                                                        sessionsHistory[i]
                                                            ['end_time'])),
                                            style: TextStyle(
                                                color: const Color(0xFF618264),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.collections_bookmark_rounded,
                                            color: const Color(0xFF618264),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            calculateSessionDuration(
                                                        sessionsHistory[i]
                                                            ['start_time'],
                                                        sessionsHistory[i]
                                                            ['end_time'])
                                                    .toString() +
                                                "'",
                                            style: TextStyle(
                                                color: const Color(0xFF618264),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.library_books,
                                            color: const Color(0xFF618264),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            sessionsHistory[i]['image_count']
                                                    .toString() +
                                                " docs",
                                            style: TextStyle(
                                                color: const Color(0xFF618264),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
