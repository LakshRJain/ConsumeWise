import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final instance=FirebaseFirestore.instance;

// Create a StreamProvider to handle the recipes data from Firebase
final recipeProvider = StreamProvider((ref) {
  // Fetch the document snapshot stream from Firestore
  return instance
      .collection('recipe')
      .doc('food')
      .snapshots();
});
final todaysfood = StreamProvider((ref) {
  // Fetch the document snapshot stream from Firestore
  return instance
      .collection('healthy_foods')
      .doc('food')
      .snapshots();
});
