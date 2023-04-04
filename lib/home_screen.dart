import 'package:flutter/material.dart';
import 'package:cyber_note/scan_screen.dart'; // Import your ScanScreen here
import 'package:camera/camera.dart';

import 'package:cyber_note/saved_notes.dart'; // Import your SavedNotesScreen here
// import 'package:YOUR_APP_NAME/settings_screen.dart'; // Import your SettingsScreen here

Future<bool> hasCamera() async {
  try {
    final cameras = await availableCameras();
    return cameras.isNotEmpty;
  } catch (e) {
    return false;
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cyber Note'), // Replace with your app name
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (await hasCamera()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScanScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No camera available')),
                  );
                }
              },
              child: Text('Scan a Page'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedNotesScreen()),
                );
              },
              child: Text('Saved Notes'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingsScreen()),
                // );
              },
              child: Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
