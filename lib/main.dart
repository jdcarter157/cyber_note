import 'package:flutter/material.dart';
import 'package:cyber_note/splash_screen.dart'; // Import the SplashScreen here

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Note',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Customize your app theme
      ),
      home: SplashScreen(),
    );
  }
}
