import 'package:flutter/material.dart';

class AllergiesPage extends StatefulWidget {
  final String name;
  final String dob;
  final String? gender;
  final String diet;
  final List<String> allergies;

  AllergiesPage({
    required this.name,
    required this.dob,
    required this.gender,
    required this.diet,
    required this.allergies,
  });

  @override
  _AllergiesPageState createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  List<String> _selectedAllergies = [];
  TextEditingController _customAllergyController = TextEditingController();

  final List<String> _commonAllergies = [
    'Peanuts',
    'Shellfish',
    'Dairy',
    'Eggs',
    'Soy',
    'Wheat',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAllergies = List.from(widget.allergies);
  }

  void _addCustomAllergy(String allergy) {
    if (allergy.isNotEmpty && !_selectedAllergies.contains(allergy)) {
      setState(() {
        _selectedAllergies.add(allergy);
      });
    }
    _customAllergyController.clear();
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _selectedAllergies.remove(allergy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Allergies'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Select Common Allergies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 10.0,
              children: _commonAllergies.map((allergy) {
                return FilterChip(
                  label: Text(allergy),
                  selected: _selectedAllergies.contains(allergy),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAllergies.add(allergy);
                      } else {
                        _selectedAllergies.remove(allergy);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Add Other Allergies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _customAllergyController,
              decoration: InputDecoration(
                labelText: 'Type Allergy',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _addCustomAllergy(_customAllergyController.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Allergies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 10.0,
              children: _selectedAllergies.map((allergy) {
                return Chip(
                  label: Text(allergy),
                  onDeleted: () => _removeAllergy(allergy),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': widget.name,
                  'dob': widget.dob,
                  'gender': widget.gender,
                  'diet': widget.diet,
                  'allergies': _selectedAllergies,
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
