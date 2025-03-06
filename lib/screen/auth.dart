import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/screen/home.dart';
import 'package:gen_ai/screen/signup.dart';
import 'package:gen_ai/screen/terms_conditions.dart';
import 'package:intl/intl.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>(); // Key for the form

  var _islogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredAge = '';
  File? _selectedImage;
  var _isAuthenticating = false;
  var _enteredUsername = '';
  bool _acceptedTerms = false; // Terms and conditions checkbox state
  final TextEditingController _dateController = TextEditingController();

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_islogin && !_acceptedTerms)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms and conditions to sign up'),
        ),
      );
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_islogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        if (userCredentials.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        if (!_islogin) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUpDetailsPage()));
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFCBF3F0), // Light blue
              Colors.white, // White at the bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 260,
                  ),
                  alignment: Alignment.topCenter,
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text(
                              _islogin ? 'Login' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE1A85D),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(
                            label: 'Email Address',
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Password',
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                            obscureText: true,
                          ),
                          if (!_islogin) const SizedBox(height: 20),
                          if (!_islogin)
                            _buildTextField(
                              label: 'Username',
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 6) {
                                  return 'Please enter a valid username (at least 6 characters)';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          if (!_islogin)
                            CheckboxListTile(
                              title: Row(
                                children: [
                                  const Text(
                                    'I accept the ',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TermsAndConditionsScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Terms and Conditions',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: _acceptedTerms,
                              onChanged: (newValue) {
                                setState(() {
                                  _acceptedTerms = newValue ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                            ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE1A85D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 80,
                                  vertical: 15,
                                ),
                              ),
                              child: Text(
                                _islogin ? 'Login' : 'Sign Up',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _islogin
                                    ? "Don't have an account?"
                                    : "Have an account?",
                                style: const TextStyle(color: Colors.black),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _islogin = !_islogin;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  _islogin ? "Sign Up" : "Login",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  // Helper function to create text fields with grey rounded borders
  Widget _buildTextField({
    required String label,
    required String? Function(String?) validator,
    required Function(String?) onSaved,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          // Adds a rounded grey border around the text field
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
          borderSide: BorderSide(
            color: Colors.grey.shade400, // Grey border color
            width: 1.5, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          // Rounded border when the field is focused
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.grey.shade600, // Darker grey when focused
            width: 2.0, // Border width when focused
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // Rounded border when the field is enabled but not focused
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400, // Grey border when enabled
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          // Rounded border when validation fails
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.red, // Border color when error
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // Rounded border when focused and error exists
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.red, // Border color when error and focused
            width: 2.0,
          ),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
