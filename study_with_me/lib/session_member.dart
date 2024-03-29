import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_with_me/config.dart';
import 'package:http/http.dart' as http;
import 'package:study_with_me/files_page.dart';
import 'package:study_with_me/homepage.dart';
import 'package:study_with_me/image_display_page.dart';
import 'package:study_with_me/usermanager.dart';
import 'package:path/path.dart';

class SessionMember extends StatefulWidget {
  final int sessionID;
  final Map<String, dynamic> sessionData;

  const SessionMember(
      {Key? key, required this.sessionID, required this.sessionData})
      : super(key: key);

  @override
  State<SessionMember> createState() => _SessionMemberState();
}

class _SessionMemberState extends State<SessionMember> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  List<File> selectedImages = [];
  List<Widget> images = [];

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

  Future<void> leaveSession(int userID, int sessionId) async {
    final url = Uri.parse(
        '${config.localhost}/leave_session');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"session_id": sessionId, "user_id": userID}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to leave user data');
      }
    } catch (error) {
      // Handle errors here
      print('Error: $error');
      throw error;
    }
  }

  Future<void> uploadImage(int sessionID, File image) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('${config.localhost}/upload_image?session_id=$sessionID'));

      // Attach the image file to the request
      var fileStream = http.ByteStream(image.openRead());
      var fileLength = await image.length();
      var multipartFile = http.MultipartFile('image', fileStream, fileLength,
          filename: 'image.jpg');
      request.files.add(multipartFile);

      request.headers['Content-Type'] = 'multipart/form-data';
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload Image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during file/image upload: $e');
    }
  }

  File? image;

  Future<File?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        print('No image picked');
        return null;
      }

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);

      print('Image picked successfully: ${image.path}');
      return imageTemp;
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
      return null;
    }
  }

  Future<File?> takeImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        print('No image picked');
        return null;
      }
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    return null;
  }

  Future<void> getImages(int sessionID) async {
    try {
      final response = await http.get(
        Uri.parse('${config.localhost}/get_image?session_id=$sessionID'),
      );

      if (response.statusCode == 200) {
        // Assuming the response is in JSON format
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> jsonData = jsonResponse['images'];
        for (var item in jsonData) {
          // Use the base64-encoded image data
          String imageBase64 = item['photo'];
          displayImage(imageBase64);
        }
      } else {
        print('Failed to get images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during image retrieval: $e');
    }
  }

  void displayImage(String imageBase64) {
    try {
      List<int> imageData = base64Decode(imageBase64);
      print('Image data length: ${imageData.length}');
      setState(() {
        images.add(Image.memory(Uint8List.fromList(imageData)));
      });
      print('Number of images: ${images.length}');
    } catch (e) {
      print('Error decoding image: $e');
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
        title: Text(
          'You can study now',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFDDEBDD),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            SizedBox(height: 120),
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
            SizedBox(height: 200),
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
                  child: Text('Files'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    leaveSession(UserManager.loggedInUserId!, widget.sessionID);
                    Navigator.push(
                        context,
                        // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Leave'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    // Call the function to pick an image
                    File? selectedImage = await pickImage();
                    if (selectedImage != null) {
                      print('Image picked successfully: ${selectedImage.path}');
                      // Save the selected image to the list
                      uploadImage(widget.sessionID, selectedImage);
                    } else {
                      print('No image selected or an error occurred.');
                    }
                  },
                  child: Icon(Icons.photo_library),
                ),
                MaterialButton(
                  onPressed: () async {
                    // Call the function to take an image
                    File? takenImage = await takeImage();
                    if (takenImage != null) {
                      // Save the taken image to the list
                      uploadImage(widget.sessionID, takenImage);
                    }
                  },
                  child: Icon(Icons.camera_enhance),
                ),
                MaterialButton(
                  onPressed: () async {
                    // Call the function to get images
                    await getImages(widget.sessionID);

                    // Navigate to ImageDisplayPage with the list of images
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          // Clear the images list
                          List<Image> clearedImages = List.from(images);
                          images.clear();
                          return ImageDisplayPage(images: clearedImages);
                        },
                      ),
                    );
                  },
                  child: const Text('Uploaded Photos'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
