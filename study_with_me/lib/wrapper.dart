import 'package:flutter/material.dart';
import 'package:study_with_me/get_started.dart';
import 'package:study_with_me/homepage.dart';
import 'usermanager.dart';

class Wrapper extends StatelessWidget {
  Wrapper({super.key});
  final userId = UserManager.loggedInUserId;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const GetStarted();
    }
    else {
      return HomePage();
    }
  }
}