import 'package:flutter/material.dart';
import 'package:study_with_me/get_started.dart';
import 'package:study_with_me/start_session.dart';
import 'usermanager.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Function to handle logout
  void logout(int userId) {
    UserManager.loggedInUserId = null;
  }

  final userId = UserManager.loggedInUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                    heightFactor: 6,
                    child: Text(
                      'Join a Session',
                      style:
                          TextStyle(color: Colors.green.shade700, fontSize: 25),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartSession(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                    heightFactor: 6,
                    child: Text(
                      'Start your own Session!',
                      style:
                          TextStyle(color: Colors.green.shade700, fontSize: 25),
                      softWrap: true,
                    )),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call logout function when the button is presse
                logout(userId!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GetStarted()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
