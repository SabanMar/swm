import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/all_session_test.dart';
import 'package:study_with_me/config.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:http/http.dart' as http;

class JoinSession extends StatefulWidget {
  const JoinSession({Key? key});

  @override
  State<JoinSession> createState() => _JoinSessionState();
}

class _JoinSessionState extends State<JoinSession> {
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  TextEditingController subjectController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> _selectDateTime(bool isStartTime) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (timePicked != null) {
        setState(() {
          if (isStartTime) {
            selectedStartTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              timePicked.hour,
              timePicked.minute,
            );
          } else {
            selectedEndTime = DateTime(
              picked.year,
              picked.month,
              picked.day,
              timePicked.hour,
              timePicked.minute,
            );
          }
        });
      }
    }
  }

  Future<void> joinSession(
    BuildContext context,
    String subject,
    String location,
    DateTime startTime,
    DateTime endTime,
  ) async {
    int? memberId = UserManager.loggedInUserId; // Get host ID from UserManager

    final Uri url = Uri.parse('${config.localhost}/join_session');

    final Map<String, dynamic> requestData = {
      "member_id": memberId.toString(),
      "subject": subject,
      "location": location,
      "start_time": startTime.toIso8601String(),
      "end_time": endTime.toIso8601String(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You joined the session successfully')),
        );
        // Navigate to the next screen upon successful session creation
        // Navigator.of(context).pushReplacement(...);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to join')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // List of preset subjects
  final List<String> subjects = [
    'Mathematics',
    'Chemistry',
    'History',
    'Literature',
    'Programming',
    'Physics',
    'Biology',
    'Electonics',
    'Everything'
    // Add more subjects as needed
  ];

  String? selectedSubject = 'Everything';// Variable to store the selected subject

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSubject = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  items: subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _selectDateTime(true); // Open start date time picker
                      },
                      child: Text(
                        selectedStartTime != null
                            ? 'Start Time: ${selectedStartTime!.toLocal()}'
                            : 'Select Start Time',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDateTime(false); // Open end date time picker
                      },
                      child: Text(
                        selectedEndTime != null
                            ? 'End Time: ${selectedEndTime!.toLocal()}'
                            : 'Select End Time',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), // Closing bracket for Padding widget
          Positioned(
            bottom: 75,
            right: 75,
            child: ElevatedButton(
              onPressed: () {
                print('Subject: ${selectedSubject.toString()}');
                print('Location: ${locationController.text}');
                print('Start Time: $selectedStartTime');
                print('End Time: $selectedEndTime');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllSessionsTest(
                      subject: selectedSubject.toString(),
                      location: locationController.text,
                      startTime: selectedStartTime,
                      endTime: selectedEndTime,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Icon(Icons.check),
            ),
          ),
        ], // Closing bracket for children of Stack
      ), // Closing bracket for Stack
    );
  }
}