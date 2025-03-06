import 'package:flutter/material.dart';
import 'allergies_page.dart';

class DietPage extends StatefulWidget {
  final String name;
  final String dob;
  final String? gender;
  final String diet;
  final List<String> allergies;

  DietPage({
    required this.name,
    required this.dob,
    required this.gender,
    required this.diet,
    required this.allergies,
  });

  @override
  _DietPageState createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  String? _selectedDiet;
  final List<String> _diets = ['Vegetarian', 'Vegan', 'Non Vegetarian'];

  @override
  void initState() {
    super.initState();
    _selectedDiet = widget.diet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Diet Type'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField(
              value: _selectedDiet,
              decoration: InputDecoration(labelText: 'Diet Type'),
              items: _diets.map((diet) {
                return DropdownMenuItem(
                  value: diet,
                  child: Text(diet),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedDiet = newValue as String?;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllergiesPage(
                      name: widget.name,
                      dob: widget.dob,
                      gender: widget.gender,
                      diet: _selectedDiet!,
                      allergies: widget.allergies,
                    ),
                  ),
                ).then((result) {
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                });
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}