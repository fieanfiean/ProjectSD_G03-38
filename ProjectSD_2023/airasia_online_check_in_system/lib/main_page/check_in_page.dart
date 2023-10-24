import 'package:airasia_online_check_in_system/main_page/generate_boarding_pass_page.dart';
import 'package:flutter/material.dart';

class CheckInPage extends StatefulWidget {
  // const CheckInPage({super.key});
  final Map<dynamic, dynamic> bookingData;
  final Map<dynamic, dynamic> flightData;

  CheckInPage({required this.bookingData, required this.flightData});


  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passport = TextEditingController();
  final name = TextEditingController();
  String baggage = 'No'; // Default value



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
    final bookingData = widget.bookingData;
    final flightData = widget.flightData;

    return Scaffold(
      appBar:  AppBar(
        title: Text("Check In" ),
        backgroundColor: Colors.red,
        ),
      body: Stack(
        children: <Widget>[
          buildBackgroundImage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          // const SizedBox(
          //     width: 800,
          //     child:  Text(
          //       "Search booking ticket",
          //       style: TextStyle(
          //         fontSize: 25,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     )),
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
                            return 'Please enter your full name';
                          }
                          // You can add more validation rules here
                          return null;
                        },
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        controller: name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                      height: 100,
                      width: 250,
                      child: TextFormField(
                        // Handles Form Validation for Last Name
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your passport';
                          } 
                          //else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                          //   return 'Please enter a valid email address';
                          // }
                          // You can add more validation rules here
                          return null;
                        },
                        decoration: const InputDecoration(labelText: ' Passport'),
                        controller: passport,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: Column(
                      children: [
                        const Text("Do you have baggage to check in?",
                          style: TextStyle(fontSize: 20,color: Colors.black,),
                            textAlign: TextAlign.start, // Align text to the left

                        ),
                        RadioListTile(
                          title: Text('No Baggage'),
                          value: 'No',
                          groupValue: baggage,
                          onChanged: (value) {
                            setState(() {
                              baggage = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('With Baggage'),
                          value: 'Yes',
                          groupValue: baggage,
                          onChanged: (value) {
                            setState(() {
                              baggage = value!;
                            });
                          },
                        ),
                      ],
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
                                  // searchBooking();
                                  String fullName = name.text;
                                  String userPassport = passport.text;
                                  String baggageSelection = baggage;

                                  Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GenerateBoardingPass(
                                      bookingData: bookingData, // Pass the booking data
                                      flightData: flightData, 
                                      fullName: fullName,
                                      userPassport: userPassport,
                                      baggageSelection: baggageSelection
                                        // Pass the flight data
                                    ),
                                  ),
                                  );
                                }
                                

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow[200],
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                              child: const Text(
                                'Check In',
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