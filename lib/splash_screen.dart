import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cyber_note/home_screen.dart'; // Import your HomeScreen here

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
        Duration(seconds: 3), () {}); // You can adjust the duration here
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize your background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cyber_note_logo.png', // Replace with the path to your app logo image
              width: 150, // Adjust the size as needed
            ),
            SizedBox(height: 20),
            Text(
              'Cyber Note', // Replace with your app name
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
                color: Colors.black, // Customize your text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
