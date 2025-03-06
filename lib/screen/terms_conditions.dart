import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Terms and Conditions'),
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
            'Welcome to ConsumeWise! These terms and conditions outline the rules and regulations for the use of our mobile application.',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 26),
          Text(
            '1. Acceptance of Terms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'By accessing and using the app, you accept and agree to be bound by these Terms. If you do not agree to these Terms, please refrain from using the app.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '2. Account Registration and Usage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'To use some features of the app, you may be required to register for an account.You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account.',
            style: TextStyle(fontSize: 16),
          ),
          Text('You agree to provide accurate, current, and complete information when creating your account.',
          style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '3. User Content',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You retain ownership of the personal data you provide. By submitting data, you grant ConsumeWise a license to use, display, and store the content as necessary for the operation of the app.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '4. Health and Nutrition Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'The app provides health and nutrition information based on food label data and personal details entered by users.The app is not a substitute for professional health advice. Always consult a healthcare provider before making any decisions related to your health or diet.The information provided by the app may not always be accurate or complete due to variations in product labels and external databases.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '5. Limitation of Liability',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'ConsumeWise and its developers shall not be liable for any indirect, incidental, or consequential damages arising out of your use of the app, including, but not limited to, inaccuracies in nutritional data, health analysis, or product recommendations.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          
          Text(
            '6. Third-Party Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'ConsumeWise may use third-party services such as APIs for barcode scanning, product information, and nutritional data. We are not responsible for any inaccuracies or issues caused by these third-party services.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '7. Intellectual Property Rights',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'All intellectual property rights in the app, including design, code, and content, are owned by ConsumeWise. Unauthorized use, duplication, or distribution of any material from the app is prohibited.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 35),
          Text(
            'We may suspend or terminate your account at any time for any reason, including a breach of these Terms.',
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
