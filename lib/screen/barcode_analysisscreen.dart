import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class BarcodeAnalysisScreen extends StatefulWidget {
  final String barcode; // Receive barcode from the scan page
  const BarcodeAnalysisScreen({super.key, required this.barcode});

  @override
  _BarcodeAnalysisScreenState createState() => _BarcodeAnalysisScreenState();
}

class _BarcodeAnalysisScreenState extends State<BarcodeAnalysisScreen> {
  Map<String, dynamic>? _productDetails;
  bool _isLoading = true; // Start loading true, update later

  @override
  void initState() {
    super.initState();
    _getProductDetailsFromOpenFoodFactsAPI(); // Fetch product details based on the barcode
  }

  Future<void> _getProductDetailsFromOpenFoodFactsAPI() async {
    final url =
        'https://world.openfoodfacts.org/api/v0/product/${widget.barcode}.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['product'] != null) {
          setState(() {
            _productDetails = jsonResponse['product'];
          });
        } else {
          setState(() {
            _productDetails = null; // No product found
          });
        }
      } else {
        setState(() {
          _productDetails = null; // Handle error response
        });
      }
    } catch (e) {
      print('Error: $e'); // Log error to console for debugging
      setState(() {
        _productDetails = null; // Handle exceptions
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/load2.json',
                height: 400,
                width: 400,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_productDetails != null) ...[
                      // Display product image if available
                      if (_productDetails!['image_url'] != null &&
                          _productDetails!['image_url'] != '')
                        Image.network(
                          _productDetails!['image_url'],
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 16),
                      // Display product name
                      Text(
                        _productDetails!['product_name'] ?? 'No product name',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Display ingredients
                      Text(
                        'Ingredients: ${_productDetails!['ingredients_text'] ?? 'No ingredients info'}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      // Display nutritional information
                      if (_productDetails!['nutriments'] != null) ...[
                        const Text(
                          'Nutritional Information:',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Energy: ${_productDetails!['nutriments']['energy-kcal_100g'] ?? 'N/A'} kcal/100g',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Fat: ${_productDetails!['nutriments']['fat_100g'] ?? 'N/A'} g/100g',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Carbohydrates: ${_productDetails!['nutriments']['carbohydrates_100g'] ?? 'N/A'} g/100g',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Proteins: ${_productDetails!['nutriments']['proteins_100g'] ?? 'N/A'} g/100g',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                      const SizedBox(height: 10),
                      // Display buying links if available
                      if (_productDetails!['buy_links'] != null &&
                          _productDetails!['buy_links'].isNotEmpty) ...[
                        const Text(
                          'Buy Links:',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        for (var link in _productDetails!['buy_links'])
                          if (link['url'] != null)
                            Text(
                              link['url'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                      ],
                      const SizedBox(height: 10),
                    ]
                  ],
                ),
              ),
            ),
    );
  }
}
