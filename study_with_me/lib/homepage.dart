import 'package:flutter/material.dart';
import 'package:study_with_me/get_started.dart';
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
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Homepage!',
              style: TextStyle(fontSize: 24),
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
