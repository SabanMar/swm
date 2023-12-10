import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:http/http.dart' as http;

class StartSession extends StatefulWidget {
  const StartSession({Key? key});

  @override
  State<StartSession> createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
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

  Future<void> createSession(
    BuildContext context,
    String subject,
    String location,
    DateTime startTime,
    DateTime endTime,
  ) async {
    int? hostId = UserManager.loggedInUserId; // Get host ID from UserManager

    final Uri uri = Uri.parse('http://10.0.2.2:5000/create_session');

    final Map<String, dynamic> requestData = {
      "host_id": hostId.toString(),
      "subject": subject,
      "location": location,
      "start_time": startTime.toIso8601String(),
      "end_time": endTime.toIso8601String(),
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session created successfully')),
        );
        // Navigate to the next screen upon successful session creation
        // Navigator.of(context).pushReplacement(...);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create session')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedStartTime != null && selectedEndTime != null) {
                  String subject = subjectController.text;
                  String location = locationController.text;

                  // Call createSession with all the extracted values
                  createSession(
                    context,
                    subject,
                    location,
                    selectedStartTime!,
                    selectedEndTime!,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select start and end times'),
                    ),
                  );
                }
              },
              child: Text('Start Session'),
            ),
          ],
        ),
      ),
    );
  }
}
