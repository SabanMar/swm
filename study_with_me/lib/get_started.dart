// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:study_with_me/login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Study With me',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Hero(
                tag: 'StartImage',
                child: Image.asset(
                  'assets/images/slash_screen.png',
                  width: 319,
                  height: 166,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'We are better together...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: const Color(0x00618264),
                ),
                child: const Text(
                  'GET STARTED',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ]),
      ),
    );
  }
}
