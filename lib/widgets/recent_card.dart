import 'package:flutter/material.dart';

class RecentCard extends StatelessWidget {
  final int num;
  const RecentCard({required this.num,super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: InkWell(
                borderRadius: BorderRadius.circular(8), // Ensure ripple is inside card
                onTap: () {
                  // Action when recent item 1 is clicked
                  print("Recent item 1 clicked");
                },
                splashColor: Colors.blue.withOpacity(0.2),
                child: Container(
                  height: 100,
                  width: 380, // Increased height for better visibility
                  alignment: Alignment.center,
                  child: Text(
                    'Recent item ${num}',
                    style: TextStyle(color: Colors.green.shade900),
                  ),
                ),
              ),
            );
  }
}