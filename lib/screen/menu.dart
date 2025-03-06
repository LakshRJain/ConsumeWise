import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/screen/aboutUs.dart';
import 'package:gen_ai/screen/auth.dart';
import 'package:gen_ai/screen/permision_screen.dart';
import 'package:gen_ai/screen/privacy_policy.dart';
import 'package:gen_ai/screen/profile_page.dart';
import 'package:gen_ai/screen/terms_conditions.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  Widget _buildListTile(BuildContext context, String title, Widget screen) {
    return Card(
      color: Color.fromARGB(255, 196, 227, 225),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to the respective screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
                  children: [
                    // _buildListTile(context, 'User Setup',),
                    _buildListTile(context, 'App Permissions',PermissionsScreen()),
                    _buildListTile(context, 'User Information',ProfilePage()),
                    // _buildListTile(context, 'Terms and Conditions'),
                    _buildListTile(context, 'About Us',AboutUsScreen()),
                    _buildListTile(context, 'Help Center',AboutUsScreen()),
                  ],
                ),),
            // TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));}, child: Text('User Information')),
            TextButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()), // Change this to your actual login or welcome page
                );
              }, 
              child: Text('Logout')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicy()));}, child: Text('Privay Policy')),
            TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditionsScreen()));}, child: Text('Terms and Condition')),

                ],
              ),
            SizedBox(height: 50,)
            
          ],
        ),
      ),
    );
  }
}