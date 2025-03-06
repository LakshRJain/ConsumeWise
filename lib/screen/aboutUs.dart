import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('About Us'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to ConsumeWise!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We , Atman, Laksh, Shreeya and Anushri, the creators of ConsumeWise are here to help you achieve your health goals .\nConsumeWise is your personal AI-enabled smart label reader, designed to help you make healthier food choices effortlessly. \nOur app allows you to scan food labels and barcodes, providing you with detailed insights into the nutritional value, ingredients, and potential health impacts of packaged food products. Whether you’re managing allergies, following a specific diet, or just looking to make better choices, ConsumeWise is here to guide you.\nMake informed decisions about what you eat and live a healthier lifestyle with ConsumeWise!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 16),
            
          ],
        ),
      ),
    );
  }
}
