import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;

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

  Future<void> uploadFile(String filePath) async {
    try {
      final url = Uri.parse('${config.localhost}/upload_file?session_id=${widget.sessionID}');

      var request = http.MultipartRequest('POST', url);
      request.fields['file_path'] = filePath;

      var file = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(file);

      var response = await request.send();

      if (response.statusCode == 200) {
        print('File uploaded successfully');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading file: $error');
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
              width: 70,
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
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      // Handle the selected file
                      PlatformFile file = result.files.first;
                      print('File path: ${file.path}');
                      print('File name: ${file.name}');
                      // Upload file to the server
                      try {
                        await uploadFile(file.path!);
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
