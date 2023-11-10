// ignore_for_file: library_private_types_in_public_api, unnecessary_new, avoid_print, prefer_const_constructors

import 'package:airasia_online_check_in_system/main_page/booking_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchTicketTabPage extends StatefulWidget {
  const SearchTicketTabPage({super.key});

  @override
  _MySearchTicketTabPageState createState() =>
      new _MySearchTicketTabPageState();
}

class _MySearchTicketTabPageState extends State<SearchTicketTabPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController editingController = TextEditingController();
  final bookingId = TextEditingController();
  final email = TextEditingController();


  // final duplicateItems = List<String>.generate(10, (i) => "Item $i");
  var items = <String>[];

  @override
  void initState() {
    // items = duplicateItems;
    super.initState();
  }

  void filterSearchResults(String query) {
    setState(() {
      // items = duplicateItems
      //     .where((item) => item.toLowerCase().contains(query.toLowerCase()))
      //     .toList();
    });
  }

  Widget buildBackgroundImage() {
  return SizedBox(
    width: 800,
    child: Image.asset(
      'assets/background-wallpaper.jpg', // Replace with your image asset path
      fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
    ),
  );
}

  void searchBooking() {
    final String enteredBookingId = bookingId.text.trim();
    final String userEmail = email.text.trim();
    // print(userEmail);
    // print(enteredBookingId);

    // Create a reference to the "bookings" node in your Firebase Realtime Database
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('booking');

    // Perform the query to search for the booking
    databaseRef
    .orderByKey()
    .equalTo(enteredBookingId) // Use the new variable name here
    .onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        // Loop through the matching bookings (there could be multiple with the same bookingId)
        values.forEach((key, value) {
          if (value["email"] == userEmail) {
            // Found a matching booking
            print("Found a matching booking: $value");
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ticketBookingDetailPage(bookingId: enteredBookingId)));
          }
        });
      } else {
        // No matching booking found
        print("Booking not found.");
      }
    });

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildBackgroundImage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          const SizedBox(
              width: 800,
              child:  Text(
                "Search booking ticket",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                      height: 100,
                      width: 250,
                      child: TextFormField(
                        // Handles Form Validation for First Name
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your booking Id';
                          }
                          // You can add more validation rules here
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'booking id'),
                        controller: bookingId,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                      height: 100,
                      width: 250,
                      child: TextFormField(
                        // Handles Form Validation for Last Name
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your booking email';
                          } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          // You can add more validation rules here
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'booking email'),
                        controller: email,
                      ),
                    ),
                  ),
                   Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 330,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (){
                                // String updatedUsername = firstNameController.text + " " + secondNameController.text;
                                // // Validate returns true if the form is valid, or false otherwise.
                                //  if (_formKey.currentState!.validate() &&
                                //     RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text +
                                //         secondNameController.text)) {
                                //   updateUserValue(updatedUsername);
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileDetailPage()));
                                // }
                                if (_formKey.currentState!.validate()) {
                                  // Form is valid, perform the search
                                  searchBooking();
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[200],
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                              child: const Text(
                                'Search',
                                style: TextStyle(fontSize: 15,color: Colors.black),
                              ),
                            ),
                          )))
                ],
              ),
            )
            ],
          ),
        ],
      )
    );
  }
}
