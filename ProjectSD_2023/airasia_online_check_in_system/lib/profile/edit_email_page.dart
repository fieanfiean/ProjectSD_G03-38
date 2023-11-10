// ignore_for_file: unused_import, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, duplicate_ignore, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';


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
    FirebaseAuth auth = FirebaseAuth.instance;
    if (user != null) {
      try {
        List<String> signInMethods = await auth.fetchSignInMethodsForEmail(email);
        if (signInMethods.isEmpty) {
          // Email is not in use, allow the update
          // Update the email using auth.currentUser.updateEmail(newEmail);
          await user!.updateEmail(email);
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Update Successful'),
                content: Text("Please relogin."),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
          final database = FirebaseDatabase.instance.ref();
          final userData = database.child('user/' + user!.uid);
          userData
          .update({'email': email,'type': 'passenger', 'uid':user!.uid, 'username': user!.displayName});
          Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginView())
                );
        } else {
          // Email is already in use
          // Handle this case, e.g., show an error message to the user
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text("Email had been used"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }
        // Update the user's email address

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
          print('Error updating Email: ${e.message}');
        }
      } catch (e) {
        // Handle other errors
        print('Error updating email: $e');
        showDialog(
          context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text("Email had been used"),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        
      }
    }
  }

  Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Email Changed'),
        content: const Text('Requires recent login. Please reauthenticate.'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginView()));
            }, 
            child:  const Text('OK'),
          ),
        ],
      ); 
    },
  ).then((value) => value ?? false);
}

  Widget buildBackgroundImage() {
  return Container(
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
      appBar: AppBar(title: const Text('Edit Email'),backgroundColor: Colors.red,),
      body: Form(
          key: _formKey,
          child: Stack(
            children: [
              buildBackgroundImage(),
              Column(
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
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate() &&
                                  EmailValidator.validate(
                                      emailController.text)) {
                                updateUserValue(emailController.text);
                                // final shouldLogout = await showLogOutDialog(context);
                                //   if (shouldLogout) {
                                //     await FirebaseAuth.instance.signOut();
                                //     // ignore: use_build_context_synchronously
                                //     Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) => const LoginView())
                                //     );
                                //   }
                                // Navigator.pop(context,emailController.text);

                              }
                              else{
                                showDialog(
                                  context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Alert'),
                                        content: Text("Invalid email"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15,color:Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[200],
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                          ),
                        )))
              ]),
            ],
          )
        )
    );
  }
}