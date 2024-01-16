import 'package:flutter/material.dart';
import 'package:study_with_me/homepage.dart';

class EndSession extends StatefulWidget {
final int sessionID;
final Map<String, dynamic> sessionData;

  const EndSession(
      {Key? key, required this.sessionID, required this.sessionData})
      : super(key: key);

  @override
  State<EndSession> createState() => _EndSessionState();

}

class _EndSessionState extends State<EndSession> {
  
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Leave'),
                ),
              ],
            ),
    
          ],
        )
          
        
      ),
    );
   }
}