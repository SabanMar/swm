// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> sessionsHistory = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: () {
                    //EDW MARIA PAME IMAGES MIN TO KSEXASEIS!!!!!!!! ILIAS
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
                                    color:
                                        const Color.fromARGB(255, 68, 102, 70),
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
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.watch_later_rounded,
                                          color: Colors.white,
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
                                          color: Colors.white,
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
                                          color: Colors.white,
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
        ));
  }
}