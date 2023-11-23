// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final dbRef = FirebaseDatabase.instance.ref('aboutUs');

  @override
  void initState() {
    super.initState();
  }

  Widget buildBackgroundImage() {
  return Container(
    width: 800,
    height: 800,
    child: Image.asset(
      'assets/background-wallpaper.jpg', // Replace with your image asset path
      fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 222, 212, 185),
      appBar: AppBar(title:const Text('About Us'),backgroundColor: Colors.red,),
      body: 
        Stack(
          children: <Widget>[
            // Add your background image here
            buildBackgroundImage(),
      
            Column(
              children: [
                Expanded(
                  child: FirebaseAnimatedList(
                    query: dbRef,
                    itemBuilder:(context, snapshot, animation, index){
                      final section = snapshot.value as Map<dynamic, dynamic>;
                      return _buildSection(
                        section['title'].toString(),
                        section['content'].toString(),
                        index
                      );
                    }
                  )
                )
              ],
          )
        ],
      ),
    );
  }

  List<Color> sectionColors = [
  Color.fromARGB(255, 145, 188, 209),
  Color.fromARGB(255, 246, 222, 134),
  // Colors.lightBlueAccent,
  // Colors.amberAccent,
  // Add more colors as needed
  ];

  List<IconData> sectionIcons = [
  Icons.info,
  Icons.flag,
  Icons.check,
  Icons.remove_red_eye,
];

  Widget _buildSection(String title, String subtitle, int index) {
    IconData icon = sectionIcons[index % sectionIcons.length]; // Get the icon
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
          children: [
            Icon(
              icon,
              size: 24.0,
              color: Colors.black,
            ),
            SizedBox(width: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ],
        ),
          Text(
            subtitle, // Use the passed subtitle here
            style: const TextStyle(
              fontSize: 18.0,
              fontStyle: FontStyle.italic,
              color: Colors.black
            ),
          ),
          const SizedBox(height: 8.0),
          Container(child: const Divider(color: Colors.black,),),
        ],
      ),
    );
  }
}