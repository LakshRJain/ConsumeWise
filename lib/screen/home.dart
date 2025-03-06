
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gen_ai/colors/app_colors.dart';
import 'package:gen_ai/screen/image_capture_screen.dart';
import 'package:gen_ai/screen/menu.dart';
import 'package:gen_ai/screen/profile_page.dart';
import 'package:gen_ai/screen/start.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected index

  // final List<Widget> _pages = [
  //   const Center(child: Text('Profile Screen')),
  //   const Center(child: Text('Scan Screen')),
  //   const Center(child: Text('Search Screen')),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(index);
      if(index==2){
        
        main=Menu();
      }else if(index==1){
        main=ImageCaptureScreen();

      }else{
        main= start();
      } // Update the selected index
    });
  }
  
  Widget main=start();
  @override
  Widget build(BuildContext context) {
     
    
        return Scaffold(
          
          extendBody: true,
        appBar: AppBar(
          title: const Text(
            'ConsumeWise',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: main,
        bottomNavigationBar:
           Padding(

            padding: EdgeInsets.only(top: 8),
            child: CurvedNavigationBar(
              
              backgroundColor: Colors.transparent,
              height: 60,
              animationCurve: Curves.fastEaseInToSlowEaseOut,
              color: AppColors.bgColor.withOpacity(0.5),
              animationDuration:Duration(milliseconds: 900) ,
              
              items:const [
                Icon(Icons.home),
                Icon(Icons.qr_code_scanner),
                Icon(Icons.person)
              ],
              
              onTap: _onItemTapped,
            ),
          ),
        
      );
      }
    
  }

