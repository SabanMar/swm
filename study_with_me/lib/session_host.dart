import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/files_page.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:path/path.dart';

class SessionHost extends StatefulWidget {
  final int sessionID;
  final Map<String, dynamic> sessionData;

  const SessionHost(
      {Key? key, required this.sessionID, required this.sessionData})
      : super(key: key);

  @override
  State<SessionHost> createState() => _SessionHostState();
}

class _SessionHostState extends State<SessionHost> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _timer.cancel(); // Pause the timer
    } else {
      startTimer(); // Resume the timer
    }
  }

  Future<void> uploadFile(int sessionID, int userID, File file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${config.localhost}/upload_file?session_id=$sessionID&user_id=$userID'));

      // Add the file to the request
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during file upload: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
              'Timer',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 177,
              height: 177,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  formatTime(_elapsedSeconds),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 100,
              height: 25,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  '${widget.sessionData['subject']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {},
              child: const Text('End'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(type: FileType.any);
                    if (result != null) {
                      // Handle the selected file
                      File file = File(result.files.single.path!);
                      // Upload file to the server
                      try {
                        await uploadFile(widget.sessionID,
                            UserManager.loggedInUserId as int, file);
                      } catch (error) {
                        print('Error uploading file: $error');
                      }
                    }
                  },
                  child: const Text('Upload'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Call the function to navigate to SessionFilesScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionFilesScreen(sessionID: widget.sessionID),
                      ),
                    );
                  },
                  child: const Text('Files'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    togglePause();
                  },
                  child: Text(_isPaused ? 'Back to work' : 'Break'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
