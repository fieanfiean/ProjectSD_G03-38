import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';


class EditEmailPage extends StatefulWidget {
  const EditEmailPage({super.key});

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

void updateUserValue(String email) async{
    if (user != null) {
      try {
        // Update the user's email address
        await user!.updateEmail(email);

        // If the email update is successful, the user's email will be changed.
        // You may also want to update the user's email in your Firestore or other databases.

        print('Email updated successfully');
      } on FirebaseAuthException catch (e) {
        // Handle any FirebaseAuthException that may occur
        if (e.code == 'requires-recent-login') {
          // The user must reauthenticate before updating email
          // You can ask the user to re-enter their password and then reauthenticate
          // by calling `reauthenticateWithCredential` before calling `updateEmail`.
          print('Requires recent login. Please reauthenticate.');
        } else {
          print('Error updating email: ${e.message}');
        }
      } catch (e) {
        // Handle other errors
        print('Error updating email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Email')),
      body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                    width: 320,
                    child: Text(
                      "What's your email?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
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
                              return 'Please enter your email.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Your email address'),
                          controller: emailController,
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
                                  EmailValidator.validate(
                                      emailController.text)) {
                                updateUserValue(emailController.text);
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