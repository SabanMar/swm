import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_with_me/session_details_host.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/config.dart';

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
  TextEditingController maxMembersController = TextEditingController();

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
      String maxMembers) async {
    int? hostId = UserManager.loggedInUserId; // Get host ID from UserManager

    final Uri uri = Uri.parse('${config.localhost}/create_session');

    final Map<String, dynamic> requestData = {
      "host_id": hostId.toString(),
      "subject": subject,
      "location": location,
      "start_time": startTime.toIso8601String(),
      "end_time": endTime.toIso8601String(),
      "max_members": maxMembers
    };

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session created successfully')),
        );

        // Extract session ID from the response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        int sessionID = responseData[
            'session_id']; // Assuming 'session_id' contains the session ID

        // Navigate to the SessionDetailsHost page with the received session ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionDetailsHost(sessionID: sessionID),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create session')),
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
                  TextFormField(
                    controller: maxMembersController,
                    decoration: const InputDecoration(
                      labelText: 'Members(1-5)',
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          Positioned(
            bottom: 75,
            right: 75,
            child: ElevatedButton(
              onPressed: () {
                if (selectedStartTime != null && selectedEndTime != null) {
                  String subject = subjectController.text;
                  String location = locationController.text;
                  String maxMembers = maxMembersController.text;

                  // Call createSession with all the extracted values
                  createSession(context, subject, location, selectedStartTime!,
                      selectedEndTime!, maxMembers);
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
                    )
                  ),
              child: const Icon(Icons.check),
            ),
          ),
        ],
      ),
    );
  }
}
