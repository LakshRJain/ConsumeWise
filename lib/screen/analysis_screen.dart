import 'dart:convert';
import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image/image.dart' as img;
import 'package:lottie/lottie.dart';

class AnalysisScreen extends StatefulWidget {
  final File image;
  const AnalysisScreen({super.key, required this.image});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final instance = FirebaseFirestore.instance;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;
  String? _responseText;
  bool _isLoading = false;
  String extractedText = "";
  String extractedBarcode = "";
  Map<String, dynamic>? nutrientsData; // Store parsed nutrients data
  var userdata;
  late List<String> allergies = [];
  late String diet;
  @override
  void initState() {
    super.initState();
    firebase();
    _performOcrAndBarcodeScan();
  }

  void firebase() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await instance.collection('users').doc(authenticatedUser.uid).get();

      if (snapshot.exists) {
        setState(() {
          userdata = snapshot.data();
          allergies = List<String>.from(userdata['allergies'] ?? []);
        });
        print(userdata.toString());
        diet = userdata['diet'];
        print(diet);
      } else {
        print('No user data found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _performOcrAndBarcodeScan() async {
    setState(() {
      _isLoading = true;
    });

    final resizedImage = await _resizeImage(widget.image);
    await _extractTextAndBarcodeFromImage(resizedImage);
    await _sendDataToGeminiAPI();

    setState(() {
      _isLoading = false;
    });
  }

  Future<File> _resizeImage(File imageFile) async {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: 800);
    final resizedFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(resizedImage));
    return resizedFile;
  }

  Future<void> _extractTextAndBarcodeFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    final barcodeScanner = BarcodeScanner();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      extractedText = recognizedText.text;

      final List<Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        extractedBarcode = barcodes.first.displayValue ?? "No barcode found";
      } else {
        extractedBarcode = "No barcode detected";
      }
    } catch (e) {
      print("Error during OCR and barcode extraction: $e");
    } finally {
      await textRecognizer.close();
      await barcodeScanner.close();
    }

    setState(() {});
  }

  Future<void> _sendDataToGeminiAPI() async {
    setState(() {
      _isLoading = true;
    });

    const apiKey =
        'AIzaSyCvunCMZfFccB8jJN0-mZlLgfLM1kZrKcE'; // Replace with actual API key
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey';

    String prompt = '''
    The list of ingredients is: $extractedText
    The barcode scanned is: $extractedBarcode.
    These are my allergies $allergies.
    This is my diet $diet
    Suppose you are a health analyst.
    Based on the list of ingredients, analyse the relevenat content and showcase a detail of nutrients and ingredients used,their health benefits and health hazards.
    Also take acount my allegies and diet and analyze accordingly.
    The response should be professional and user fiendly to read and understand. Format the output in a manner such that it easy to read and do not exceed 100 words. 
    
    
    ''';

    final requestPayload = {
      "contents": [
        {
          "parts": [
            {
              "text": prompt,
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        if (jsonResponse['candidates'] != null &&
            jsonResponse['candidates'].isNotEmpty) {
          final candidate =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];

          setState(() {
            _responseText = candidate; // Store the full text response
          });
        } else {
          setState(() {
            _responseText = 'No candidates found in response.';
          });
        }
      } else {
        setState(() {
          _responseText =
              'Error: ${response.statusCode}, Response Body: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
              Opacity(
                opacity: 0.2,
                child: Image.file(
                  widget.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Lottie.asset(
                  'assets/animations/load2.json',
                  height: 400,
                  width: 400,
                ),
              ),
            ]),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Opacity(
                  opacity: 0.2,
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/gemini_logo.png',
                          height: 150,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 9),
                        child: Text(
                          "Analysis Result:",
                          style: TextStyle(
                            color: Color.fromARGB(255, 243, 231, 231),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _responseText != null
                          ? BlurryContainer(
                              padding: const EdgeInsets.all(20),
                              color: Colors.white.withOpacity(0.4),
                              child: Text(
                                _responseText!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 11, 11, 11)),
                              ),
                            )
                          : const Text(
                              'Analysis result will be displayed here.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 233, 16, 16)),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
