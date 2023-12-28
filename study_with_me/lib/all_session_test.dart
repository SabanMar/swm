import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/session_details_memder.dart';

class AllSessionsTest extends StatefulWidget {
  const AllSessionsTest({Key? key}) : super(key: key);

  @override
  State<AllSessionsTest> createState() => _AllSessionsTestState();
}

class _AllSessionsTestState extends State<AllSessionsTest> {
  List<Map<String, dynamic>> sessions = [];

  @override
  void initState() {
    super.initState();
    fetchAllSessions();
  }

  Future<void> fetchAllSessions() async {
    final url = Uri.parse('http://10.0.2.2:5000/get_all_sessions');

    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
              for (int i = 1; i < sessions.length; i++)
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
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                          Column(
                            children: [
                              Text("Host ID:" +
                                  sessions[i]['host_id'].toString()),
                              Text("Location:" + sessions[i]['location']),
                              Text("Subject:" + sessions[i]['subject']),
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
