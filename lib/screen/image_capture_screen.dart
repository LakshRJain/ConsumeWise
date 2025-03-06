import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gen_ai/screen/analysis_screen.dart';
import 'package:gen_ai/screen/barcode_analysisscreen.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:lottie/lottie.dart';

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({super.key});

  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _image;
  final ImagePicker _picker =
      ImagePicker(); // ImagePicker instance for camera and gallery
  final BarcodeScanner barcodeScanner =
      BarcodeScanner(); // Barcode scanner instance
  String _barcodeMessage = ""; // Message to display if no barcode is found

  // Capture image using native camera
  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // Navigate to Analysis Screen after image capture
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisScreen(image: _image!),
          ),
        );
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  // Scan barcode using native camera
  Future<void> _scanBarcode() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final inputImage = InputImage.fromFilePath(pickedFile.path);
        final barcodes = await barcodeScanner.processImage(inputImage);

        if (barcodes.isNotEmpty) {
          final scannedBarcode = barcodes.first.rawValue ?? "No value";
          print(scannedBarcode);

          // Navigate to BarcodeAnalysisScreen and pass the scanned barcode
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BarcodeAnalysisScreen(barcode: scannedBarcode),
            ),
          );
        } else {
          setState(() {
            _barcodeMessage =
                "Barcode Not Found!"; // Update message if no barcode found
          });
          print("No barcode found.");
        }
      }
    } catch (e) {
      print("Error scanning barcode: $e");
    }
  }

  @override
  void dispose() {
    barcodeScanner.close(); // Close the barcode scanner
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show loading animation
            Center(
              child:
                  Lottie.asset('assets/animations/loading.json', height: 200),
            ),
            const SizedBox(height: 20), // Space between animation and buttons
            // Display barcode message if exists
            if (_barcodeMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  _barcodeMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20), // Space between message and buttons
            // Buttons displayed in the center of the screen
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        _captureImage, // Opens native camera for image capture
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Capture Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        _scanBarcode, // Opens native camera for barcode scan
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Scan Barcode",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Additional space at the bottom
          ],
        ),
      ),
    );
  }
}
