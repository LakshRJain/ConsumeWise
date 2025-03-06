import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/screen/signup.dart';

class ProfilePage extends StatelessWidget {
  void _editProfile(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpDetailsPage()));
  }

  @override
  Widget build(BuildContext context) {
    final instance = FirebaseFirestore.instance;
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCBF3F0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'User Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE1A85D),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBF3F0), Color.fromARGB(255, 248, 240, 229)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: instance.collection('users').doc(authenticatedUser.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('No user data found');
              } else {
                var userData = snapshot.data!.data()!;

                // Handle dob field (check if it's a Timestamp or a String)
                String formattedDob = userData['dob'];
                formattedDob = formattedDob.length > 10 ? formattedDob.substring(0, 10) : formattedDob;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    _buildProfileCard(Icons.person, 'NAME', userData['username']),
                    SizedBox(height: 12),
                    _buildProfileCard(Icons.cake, 'DATE OF BIRTH', formattedDob),
                    SizedBox(height: 12),
                    _buildProfileCard(Icons.wc, 'GENDER', userData['gender']),
                    SizedBox(height: 12),
                    _buildProfileCard(Icons.restaurant, 'DIET TYPE', userData['diet']),
                    SizedBox(height: 12),
                    _buildProfileCard(Icons.local_hospital, 'ALLERGIES', (userData['allergies'] as List<dynamic>).join(', ')),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _editProfile(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE1A85D),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String fieldName, String fieldValue) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12.0), // Reduce the padding to reduce height
        child: Row(
          children: [
            Icon(icon, color: Color(0xFFECAD5A), size: 28),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fieldName,
                  style: TextStyle(
                    fontSize: 16, // Slightly smaller font size
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 6), // Reduce the space between title and value
                Text(
                  fieldValue,
                  style: TextStyle(
                    fontSize: 18, // Slightly smaller and not bold
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}