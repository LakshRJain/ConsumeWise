import 'package:flutter/material.dart';

class Recipe extends StatelessWidget {
  final int num;
  const Recipe({required this.num, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: InkWell(
                borderRadius: BorderRadius.circular(8), // Ensure ripple effect stays inside card
                onTap: () {
                  // Action when recommended item 1 is clicked
                  print("Recommended item ${num} clicked");
                },
                splashColor: Colors.blue.withOpacity(0.2),
                child: Container(
                  height: 150,
                  width: 380, // Increased height for better visibility
                  alignment: Alignment.center,
                  child: Text(
                    'Recipe ${num}',
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ),
              ),
            );
  }
}