import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SessionFilesScreen extends StatefulWidget {
  final int sessionID;

  SessionFilesScreen({required this.sessionID});

  @override
  _SessionFilesScreenState createState() => _SessionFilesScreenState();
}

class _SessionFilesScreenState extends State<SessionFilesScreen> {
  Future<String> readFileContent(String filePath) async {
    final file = File(filePath);
    return await file.readAsString();
  }

  Future<void> openFile(String fileName) async {
    final filePath = 'study_with_me/files/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      print('File exists: $filePath');
      try {
        // Continue with opening the file...
      } catch (error) {
        print('Error opening file: $error');
      }
    } else {
      print('File does not exist: $filePath');
    }
    try {
      // Check the file type based on its extension or other criteria
      if (fileName.endsWith('.txt')) {
        // Text file
        final fileContent = await readFileContent(filePath);
        displayTextFileContent(fileContent);
      }
    } catch (error) {
      print('Error opening file: $error');
    }
  }

  // Method to display the content of a text file
  void displayTextFileContent(String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Text File Content'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to display an image file
  void displayImageFile(String filePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Image File')),
          body: Image.file(File(filePath)),
        ),
      ),
    );
  }


  Future<List<Map<String, dynamic>>> getFiles(int sessionID) async {
    try {
      final url =
          Uri.parse('${config.localhost}/get_files/${widget.sessionID}');
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final files = jsonDecode(response.body)['files'];
        return files.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch session files');
      }
    } catch (error) {
      // Handle errors here
      print('Error: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
        title: Text('Session Files'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Assuming you have a future method to retrieve files
        future: getFiles(widget.sessionID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Assuming you want to display a list of files
            final files = snapshot.data as List<Map<String, dynamic>>;

            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final fileName = files[index]['file_name'];

                return ListTile(
                  title: Text(fileName),
                  onTap: () async {
                    await openFile(fileName as String);
                    print('File tapped: $fileName');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
