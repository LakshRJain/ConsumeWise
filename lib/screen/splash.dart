import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gen_ai/screen/auth.dart';
import 'package:gen_ai/screen/home.dart';

class SplashPage  extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    redirect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Image.asset('assets/images/logo2.png')
      )
    );
  }

  Future<void> redirect() async{
    await Future.delayed(const Duration(seconds:2 ,),);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context)=>StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return const AuthScreen();
        },
      ),));
  }
}