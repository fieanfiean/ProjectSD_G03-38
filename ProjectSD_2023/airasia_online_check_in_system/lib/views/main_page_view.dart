// ignore_for_file: unused_import, unused_local_variable, deprecated_member_use, prefer_interpolation_to_compose_strings, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace

import 'package:airasia_online_check_in_system/main_page/history-page.dart';
import 'package:airasia_online_check_in_system/main_page/profile_page.dart';
import 'package:airasia_online_check_in_system/main_page/search_ticket_page.dart';
import 'package:airasia_online_check_in_system/profile/profile_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';



class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
int curentPageIndex = 0;
late int _index = 0;
void onTabTapped(int index) {
      setState(() {curentPageIndex = index;});
  }



final List <Widget> _pageOptions = [
  const SearchTicketTabPage(),
  const ProfileDetailPage(),
  const ProfileTabPage(),
];

@override
  void initState() {
    super.initState();
      fetchIndex();
  }

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('AirAsia Online Check-in System'),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
          ),
          bottomNavigationBar: CustomBottomNavigationBar( // Use the custom widget
            height: 70.0, // Set your desired height here
            currentIndex: curentPageIndex,
            onTap: onTabTapped,
          ),
          body: Stack(
            children: <Widget>[
              _pageOptions[curentPageIndex],
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: (){
                    showInputDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    padding: const EdgeInsets.all(16.0),
                    primary: Colors.blue,
                    onPrimary: Colors.white
                  ),
                  child:const Icon(Icons.message_rounded),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchIndex() {
      final databaseReference = FirebaseDatabase.instance.ref();

      databaseReference.child('enquiry').child('index').onValue.listen(
        (event) {
          if (event.snapshot.value != null) {
            setState(() {
              _index = int.parse(event.snapshot.value.toString());
  print("current index:" + _index.toString());
            });
          }
        },
      );  
  }

  void addEntryWithIncrementedIndex(String content) {
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  final databaseReference = FirebaseDatabase.instance.ref();
  
  // Increment the index
  _index++;
  print("current index:" + _index.toString());

  // Update the index value in the database
  databaseReference.child('enquiry').child('index').set(_index);

  // Add the new entry with the updated index
  databaseReference.child('enquiry').child(_index.toString()).set({
    'email': userEmail,
    'content': content,
  });
}



  Future<void> showInputDialog(BuildContext context) async {
    String userInput = ''; // Initialize a variable to store user input
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    final database = FirebaseDatabase.instance.ref();
    // fetchIndex();
    // print(_index);
    
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('What is your enquiry?'), // Set the dialog title
          content: TextField(
            onChanged: (value) {
              userInput = value; // Update the user input as the user types
            },
            decoration: const InputDecoration(labelText: 'Enter something'), // Customize the input field
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog when Cancel is pressed
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                addEntryWithIncrementedIndex(userInput);
                Navigator.of(context).pop(); // Close the dialog when OK is pressed
              },
            ),
          ],
        );
      },
    );
  }
}


class CustomBottomNavigationBar extends StatelessWidget {
  final double height; // Specify the desired height
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({
    required this.height,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // Set the desired height
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.amber[800],
        selectedItemColor: Colors.blue,
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
