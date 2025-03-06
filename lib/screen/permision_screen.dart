import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool cameraPermissionGranted = false;
  bool microphonePermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final microphoneStatus = await Permission.microphone.status;

    setState(() {
      cameraPermissionGranted = cameraStatus.isGranted;
      microphonePermissionGranted = microphoneStatus.isGranted;
    });
  }

  Future<void> _requestCameraPermission() async {
    if (cameraPermissionGranted) {
      // Camera permission is already granted.
      return;
    }

    final status = await Permission.camera.request();

    if (status.isGranted) {
      setState(() {
        cameraPermissionGranted = true;
      });
    } else if (status.isDenied) {
      // Permission denied, show a message or handle as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required.')),
      );
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, navigate to settings
      _showSettingsDialog('Camera permission is permanently denied.');
    }
  }

  Future<void> _requestMicrophonePermission() async {
    if (microphonePermissionGranted) {
      // Microphone permission is already granted.
      return;
    }

    final status = await Permission.microphone.request();

    if (status.isGranted) {
      setState(() {
        microphonePermissionGranted = true;
      });
    } else if (status.isDenied) {
      // Permission denied, show a message or handle as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required.')),
      );
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, navigate to settings
      _showSettingsDialog('Microphone permission is permanently denied.');
    }
  }

  void _showSettingsDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Open app settings
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Settings',),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Permissions'),backgroundColor: Colors.transparent,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Camera Permission'),
              trailing: Switch(
                value: cameraPermissionGranted,
                onChanged: (value) async {
                  if (value) {
                    await _requestCameraPermission();
                  } else {
                    // Users cannot toggle off permission through the app
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You cannot disable camera permission from here.')),
                    );
                  }
                },
              ),
            ),
            ListTile(
              title: Text('Microphone Permission'),
              trailing: Switch(
                value: microphonePermissionGranted,
                onChanged: (value) async {
                  if (value) {
                    await _requestMicrophonePermission();
                  } else {
                    // Users cannot toggle off permission through the app
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You cannot disable microphone permission from here.')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
