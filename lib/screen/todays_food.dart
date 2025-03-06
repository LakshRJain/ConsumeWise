import 'package:flutter/material.dart';
import 'package:gen_ai/firestore/healthy_food.dart';

class TodaysFood extends StatelessWidget {
  final HealthyFood todayfood;

  TodaysFood({required this.todayfood, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(todayfood.bgImageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title:Text('') ,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon:Container(
          height: 50,
          width: 50,
          decoration:  BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color :Colors.black,
          ),
        ) ,),
    ),
        backgroundColor: Colors.transparent,
        body: DraggableScrollableSheet(
          initialChildSize: 0.4, // Adjust this based on your needs
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of the scrollable sheet
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),  // Curved edges
                  topRight: Radius.circular(50), // Curved edges
                ),
              ),
              child: Material(
                color: Colors.transparent, // Avoid multiple Scaffold issues
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, top: 30, right: 25, bottom: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center the name text only
                        Center(
                          child: Text(
                            todayfood.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Left-aligned text
                        Text(
                          'About',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          todayfood.about,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Benefits',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          todayfood.benefits,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Nutritional Value',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          todayfood.nutritionalValue,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
