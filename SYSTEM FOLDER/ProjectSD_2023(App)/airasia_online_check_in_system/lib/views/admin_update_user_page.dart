// ignore_for_file: unused_import, unnecessary_import, camel_case_types, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, sort_child_properties_last
import 'dart:convert';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class adminPage extends StatefulWidget {
  const adminPage({super.key});
  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
  Widget buildBackgroundImage() {
  return SizedBox(
    width: 800,
    child: Image.asset(
      'assets/background-wallpaper.jpg', // Replace with your image asset path
      fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
    ),
  );
}

 Future<void> scanBoardingPass() async {
    try {
      var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
     
            print("Result is "+ result);
              final decodedResult = json.decode(result);
              if (decodedResult.containsKey('BookingId')) {
                final BookingId = decodedResult['BookingId'];
                print('BookingId: $BookingId');
                final database = FirebaseDatabase.instance.ref();
                final userData = database.child('booking/' + BookingId);
                userData
                .update({'status': 'Boarding'});
              } else {
                print('BookingId not found in the scanned data.');
              }
    } on FormatException {
      // Handle exception if the QR code is not formatted correctly
    } catch (e) {
      // Handle other exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          buildBackgroundImage(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: scanBoardingPass,
                  child: const Text('Scan Boarding Pass', style: TextStyle(fontSize: 15, color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[200],
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          await FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginView()));
                        }
                      },
                  child: const Text('Logout',style: TextStyle(fontSize: 15, color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[200],
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                ),
                const SizedBox(height: 20),
              ],),),],),);
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}