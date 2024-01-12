import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class SessionFilesScreen extends StatefulWidget {
  final int sessionID;

  SessionFilesScreen({required this.sessionID});

  @override
  _SessionFilesScreenState createState() => _SessionFilesScreenState();
}

class _SessionFilesScreenState extends State<SessionFilesScreen> {
  Future<void> openFile(String fileName, String fileContent) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Create a temporary file to store the content
      final tempFile = File(filePath);
      await tempFile.writeAsBytes(base64Decode(fileContent));

      final fileUri = Uri.file(filePath);

      // Open the file using the default app
      await launchUrl(fileUri);
    } catch (error) {
      print('Error opening file: $error');
    }
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
                final fileContent = files[index]['file_content'];

                return ListTile(
                  title: Text(fileName),
                  onTap: () async {
                    await openFile(fileName, fileContent);
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
