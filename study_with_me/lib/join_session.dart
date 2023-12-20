import 'dart:convert';
import 'package:flutter/material.dart';
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

    final Uri uri = Uri.parse('http://127.0.0.1:5000/join_session');

    final Map<String, dynamic> requestData = {
      "member_id": memberId.toString(),
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
                TextFormField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                  ),
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
            bottom: 75.0,
            right: 70.0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedStartTime != null && selectedEndTime != null) {
                      String subject = subjectController.text;
                      String location = locationController.text;

                      // Call joinSession with all the extracted values
                      joinSession(
                        context,
                        subject,
                        location,
                        selectedStartTime!,
                        selectedEndTime!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select start and end times'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Center(child: Icon(Icons.check)),
                ),
              ),
            ),
          ),
        ], // Closing bracket for children of Stack
      ), // Closing bracket for Stack
    );
  }
}
