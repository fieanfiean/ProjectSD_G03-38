import 'package:airasia_online_check_in_system/main_page/check_in_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';



class ticketBookingDetailPage extends StatelessWidget {
  // const ticketBookingDetailPage({super.key});
    final String bookingId;
    ticketBookingDetailPage({required this.bookingId});

Widget buildBackgroundImage() {
  return SizedBox(
    width: 800,
    child: Image.asset(
      'assets/background-wallpaper.jpg', // Replace with your image asset path
      fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          buildBackgroundImage(),
          StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref()
            .child('booking')
            .child(bookingId)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
      Map<dynamic, dynamic> bookingData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>; // Explicit casting      // Display the booking details here
            String flightId = bookingData['flightId'];
            return StreamBuilder(
              stream: FirebaseDatabase.instance
                  .ref()
                  .child('flight')
                  .child(flightId)
                  .onValue,
              builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> flightSnapshot) {
                if (flightSnapshot.hasData && flightSnapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> flightData =
                      flightSnapshot.data!.snapshot.value as Map<dynamic, dynamic>; // Explicit casting

                  // Display the booking and flight details here
                  return ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text('Booking ID: ${bookingData['bookingId']}'),
                      ),
                      ListTile(
                        title: Text('Email: ${bookingData['email']}'),
                      ),
                      ListTile(
                        title: Text('Flight ID: $flightId'),
                      ),
                      ListTile(
                        title: Text('Seat: ${bookingData['seat']}'),
                      ),
                      ListTile(
                        title: Text('Destination: ${flightData['destination']}'),
                      ),
                      ListTile(
                        title: Text('Departure Date: ${flightData['departureDate']}'),
                      ),
                      ListTile(
                        title: Text('Departure Time: ${flightData['departureTime']}'),
                      ),
                      ListTile(
                        title: Text('Arrival Time: ${flightData['arrivalTime']}'),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CheckInPage(
                                      bookingData: bookingData, // Pass the booking data
                                      flightData: flightData,   // Pass the flight data
                                    ),
                                  ),
                                );                             
                                // if (_formKey.currentState!.validate()) {
                                //   // Form is valid, perform the search
                                //   searchBooking();
                                // }

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[200],
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                              child: const Text(
                                'Check in',
                                style: TextStyle(fontSize: 15,color: Colors.black),
                              ),
                            ),
                          )))
                      // Add more ListTile widgets for other data
                    ],
                  );
                } else {
                  // Flight data not available
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            // Booking data not available
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
        ],
      )
    );
  }
}