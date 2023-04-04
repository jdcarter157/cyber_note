import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  String _extractedText = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _saveNote() async {
    if (_extractedText.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notes = prefs.getStringList('notes') ?? [];
      notes.add(_extractedText);
      await prefs.setStringList('notes', notes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note saved')),
      );
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      final firstCamera = cameras.first;
      _controller = CameraController(firstCamera, ResolutionPreset.high,
          enableAudio: false);
      _controller?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } else {
      // Handle the case when there is no available camera
      setState(() {
        _extractedText = 'No available camera found';
      });
    }
  }

  Future<void> _scanImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      await _initializeCamera();
    }

    final image = await _controller!.takePicture();
    final inputImage = InputImage.fromFile(File(image.path));
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final visionText = await textDetector.processImage(inputImage);

    setState(() {
      _extractedText = visionText.text;
    });

    await textDetector.close();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan a Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            Expanded(
              child: CameraPreview(_controller!),
            ),
          ElevatedButton(
            onPressed: () async {
              await _scanImage();
            },
            child: Text('Scan'),
          ),
          ElevatedButton(
            onPressed: _extractedText.isNotEmpty
                ? () async {
                    await _saveNote();
                  }
                : null,
            child: Text('Save'),
          ),
          if (_extractedText.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(_extractedText),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
