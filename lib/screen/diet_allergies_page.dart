import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/screen/home.dart';

class DietAllergiesPage extends StatefulWidget {
  final String name;
  final DateTime dob;
  final String gender;

  DietAllergiesPage({
    required this.name,
    required this.dob,
    required this.gender,
  });

  @override
  _DietAllergiesPageState createState() => _DietAllergiesPageState();
}

class _DietAllergiesPageState extends State<DietAllergiesPage> {
  String dietType = '';
  List<String> selectedAllergies = [];
  final List<String> commonAllergies = [
    'Peanuts',
    'Shellfish',
    'Dairy',
    'Eggs',
    'Soy',
    'Wheat',
  ];
  TextEditingController _otherAllergyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCBF3F0), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  'Select Your Diet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1A85D),
                  ),
                ),
                SizedBox(height: 10),
                _buildDropdownField(
                  label: 'Diet Type',
                  value: dietType,
                  items: ['Veg', 'Non-Veg', 'Vegan'],
                  onChanged: (value) => setState(() {
                    dietType = value!;
                  }),
                ),
                SizedBox(height: 20),
                Text(
                  'Select Common Allergies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1A85D),
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: commonAllergies.map((allergy) {
                    final isSelected = selectedAllergies.contains(allergy);
                    return ChoiceChip(
                      label: Text(allergy),
                      selected: isSelected,
                      selectedColor: const Color.fromARGB(255, 24, 180, 152),
                      backgroundColor: Colors.white,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedAllergies.add(allergy);
                          } else {
                            selectedAllergies.remove(allergy);
                          };
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  'Add Other Allergies',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE1A85D),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Type Allergy',
                        controller: _otherAllergyController,
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              selectedAllergies.add(value);
                              _otherAllergyController.clear();
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 20),
                if (selectedAllergies.isNotEmpty) ...[
                  Text(
                    'Selected Allergies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE1A85D),
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: selectedAllergies.map((allergy) {
                      return Chip(
                        label: Text(allergy),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {
                          setState(() {
                            selectedAllergies.remove(allergy);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final authenticatedUser =
                          FirebaseAuth.instance.currentUser!;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(authenticatedUser.uid)
                          .set({
                        'username': widget.name,
                        'dob': widget.dob.toString(),
                        'gender': widget.gender,
                        'diet': dietType,
                        'allergies': selectedAllergies,
                      });
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE1A85D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    ),
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required Function(String) onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFFE1A85D),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.add),
          color: Color(0xFFE1A85D),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              setState(() {
                selectedAllergies.add(controller.text);
                controller.clear();
              });
            }
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFFE1A85D),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 2,
          ),
        ),
      ),
      value: value.isEmpty ? null : value,
      items: items
          .map((label) => DropdownMenuItem(
                child: Text(label),
                value: label,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}