import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          
          SizedBox(height: 8),
          Text(
            'At ConsumeWise, we are committed to protecting your privacy. This Privacy Policy outlines the types of personal information we collect, how we use it, and how we protect your data.',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 26),
          Text(
            '1. Information We Collect',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We may collect the following types of information from users:\nPersonal Information: Information such as your name, email address, gender, diet preferences, allergies, and health conditions that you provide when you register or update your profile.\nUsage Data: Data about how you use the app, such as scanned product history, app usage patterns, and device information.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '2. How We Use Your Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We use your personal information to:\nProvide personalized nutritional and health analysis.\nTailor product recommendations and alternative food suggestions based on your dietary preferences and health conditions.\nImprove our services and user experience.',
            style: TextStyle(fontSize: 16),
          ),
          
          SizedBox(height: 16),
          Text(
            '3. Data Sharing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We may share your information with trusted third-party service providers (such as barcode scanning services or nutrition databases) to help us operate the app. We do not sell your data to third parties.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '4. Data Storage and Security',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We store your personal information securely using Firebase Firestore and other industry-standard security measures.\nWe take reasonable precautions to protect your information, but we cannot guarantee absolute security due to potential security breaches in online systems.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '5. User Control Over Personal Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You have the right to:\nAccess and update your personal data via the user profile page.\nRequest deletion of your account and associated data.\nOpt out of personalized services and data collection by changing your account settings.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          
          Text(
            '6. Retention of Data',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'We retain your personal data for as long as your account is active or as needed to provide services. If you request to delete your account, we will permanently erase your data.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '7. Cookies and Tracking',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('We may use cookies to enhance the user experience by storing user preferences and tracking usage patterns. You can manage or disable cookies through your device settings.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '8. Changes to Privacy Policy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('We may update this policy from time to time. Any changes will be posted within the app, and your continued use of the app will constitute acceptance of these changes.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 50),
         
        ],
      ),
    );
  }
}
