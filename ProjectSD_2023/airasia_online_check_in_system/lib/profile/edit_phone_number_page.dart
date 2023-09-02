// ignore: unused_import
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPhoneNumberPage extends StatefulWidget {
  const EditPhoneNumberPage({super.key});

  @override
  State<EditPhoneNumberPage> createState() => _EditPhoneNumberPageState();
}

class _EditPhoneNumberPageState extends State<EditPhoneNumberPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void updateUserValue(String phone) async {
    try {
    // Validate and format the phone number (adjust the formatting logic as needed)
    if (!isNumeric(phone) || phone.length < 10) {
      // Handle invalid phone number
      return;
    }

    // Format the phone number with the appropriate country code
    String formattedPhoneNumber = "+6$phone"; // Adjust the country code as needed
  print(formattedPhoneNumber);
    // Verify the user's current phone number first (optional)
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: currentUser.uid, // You may need to fetch the verification ID
        smsCode: formattedPhoneNumber, // Use the formatted phone number as the SMS code
      );

      await currentUser.linkWithCredential(credential);
    }

    // Reload the user to get the updated information
    await currentUser?.reload();

    // Check if the phone number was successfully updated
    user = FirebaseAuth.instance.currentUser;
    if (user?.phoneNumber == formattedPhoneNumber) {
      // Phone number updated successfully
      Navigator.pop(context);
    } else {
      // Handle update failure
    }
    } catch (e) {
      // Handle Firebase Authentication errors
      print('Error updating phone number: $e');
    }
  }

  bool isNumeric(String str) {
  // ignore: unnecessary_null_comparison
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Phone Number')),
      body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 320,
                    child: const Text(
                      "What's Your Phone Number?",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!isNumeric(value)) {
                              return 'Only Numbers Please';
                            } else if (value.length < 11) {
                              return 'Please enter a VALID phone number';
                            }
                            return null;
                          },
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Your Phone Number',
                          ),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate() &&
                                  isNumeric(phoneController.text)) {
                                updateUserValue(phoneController.text);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        )
    );
  }
}


