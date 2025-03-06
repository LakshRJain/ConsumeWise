import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gen_ai/screen/auth.dart';
import 'package:gen_ai/screen/splash.dart';
import 'package:provider/provider.dart' as provider;
import 'package:gen_ai/screen/home.dart';

import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

 runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blueGrey
        ).copyWith(
          secondary: Colors.lightBlue.shade100, // Defining the accent color
        ),
      ),
      home: SplashPage()
    );
  }
}
