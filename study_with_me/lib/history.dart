// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/session_details_member.dart';

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
              for (int i = 0; i < sessionsHistory.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionDetailsUser(
                          sessionID: sessionsHistory[i]['id'],
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
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                          Column(
                            children: [
                              Text("Host ID:" +
                                  sessionsHistory[i]['host_id'].toString()),
                              Text(
                                  "Location:" + sessionsHistory[i]['location']),
                              Text("Subject:" + sessionsHistory[i]['subject']),
                            ],
                          ),
                          Icon(
                            Icons.menu_book_sharp,
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
