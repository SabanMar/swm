import 'package:flutter/material.dart';
import 'package:study_with_me/start_session.dart';
import 'package:study_with_me/join_session.dart';
import 'usermanager.dart';
import 'profile.dart';

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
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDEBDD),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0), // Add padding/margin around the icon
            child: IconButton(
              icon: const Icon(Icons.account_circle),
              iconSize: 40,
              onPressed: () {
                Navigator.push(
                  context,
                  // ?? 0 set the userID = 0 if the UserManager.loggedInUserId is null
                  MaterialPageRoute(
                      builder: (context) =>
                          Profile(userID: UserManager.loggedInUserId ?? 0)),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JoinSession(),
                  ),
                );
              },
              child: Container(
                width: 270,
                height: 200,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  heightFactor: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Join',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 51, 104, 54),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      Text('Session',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 51, 104, 54),
                              fontSize: 35,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartSession(),
                  ),
                );
              },
              child: Container(
                width: 270,
                height: 200,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  heightFactor: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 51, 104, 54),
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      Text('Session',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 51, 104, 54),
                              fontSize: 35,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
