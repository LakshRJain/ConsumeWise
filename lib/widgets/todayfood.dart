import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_ai/firestore/healthy_food.dart';
import 'package:gen_ai/riverpod/riverpod_providers.dart';
import 'package:gen_ai/screen/todays_food.dart';

// Replace this with your actual provider for fetching healthy foods
final healthyFoodsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return FirebaseFirestore.instance.collection('healthy_foods').doc('food').snapshots().map((snapshot) {
    return snapshot.data() ?? {};
  });
});

class Food extends ConsumerWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current day of the year to rotate foods daily
    int dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;

    final healthyFoodsAsyncValue = ref.watch(todaysfood);

    return healthyFoodsAsyncValue.when(
      data: (DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          return const Center(child: Text('No foods available'));
        }  
        var foodMap = snapshot.data() as Map<String, dynamic>;


        // Convert the map into a list of HealthyFood objects
        List<HealthyFood> foods = foodMap.entries.map((entry) {
          return HealthyFood.fromFirestore(entry.key, entry.value as Map<String, dynamic>);
        }).toList();

        // Use the dayOfYear to select a different food each day
        HealthyFood foodOfTheDay = foods[(dayOfYear) % foods.length];

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Color(0xFFECAD5A),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Navigate to the details screen for the selected food
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodaysFood(todayfood: foodOfTheDay),
                ),
              );
            },
            splashColor: Colors.blue.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        foodOfTheDay.imageUrl,
                        height: 120,
                        width: 130,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Failed to load image'));
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          foodOfTheDay.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
