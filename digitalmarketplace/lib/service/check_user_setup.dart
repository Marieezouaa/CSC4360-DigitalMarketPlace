import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digitalmarketplace/pages/intro_screens/setup_screen.dart';  // Your setup screen
import 'package:digitalmarketplace/pages/app_screens/home_screen.dart'; // Your home screen

void checkUserSetup(BuildContext context) async {
  // Check if the user is signed in
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // Get the flag from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSetupComplete = prefs.getBool('isSetupComplete') ?? false;

    if (isSetupComplete) {
      // If setup is complete, navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If setup is not complete, navigate to the setup screen
      Navigator.pushReplacementNamed(context, '/setup');
    }
  } else {
    // If the user is not signed in, navigate to the login screen
    Navigator.pushReplacementNamed(context, '/login');
  }
}
