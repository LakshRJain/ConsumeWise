import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/colors/app_colors.dart';
import 'package:gen_ai/widgets/article.dart';
import 'package:gen_ai/widgets/recent_card.dart';
import 'package:gen_ai/widgets/recipe.dart';
import 'package:gen_ai/widgets/recommended_card.dart';
import 'package:gen_ai/widgets/todayfood.dart';

class start extends StatelessWidget {
  start({super.key});
  final instance = FirebaseFirestore.instance;
  final authenticatedUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: instance
                    .collection('users')
                    .doc(authenticatedUser.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No user data found');
                  } else {
                    var userData = snapshot.data!.data()!;
                    return Text(
                      'Hi ${userData['username']},',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Today\'s healthy food',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Food(), // Ensure this widget does not have layout issues

              const SizedBox(height: 24),
              RecommendedRecipes(), // Ensure this widget does not have layout issues

              const SizedBox(height: 24),
              ArticlesPage(), // Ensure this widget does not have layout issues

              const SizedBox(height: 24),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
