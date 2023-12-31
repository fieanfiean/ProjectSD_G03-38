// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_interpolation_to_compose_strings, sort_child_properties_last, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
    const EditNamePage({super.key});



  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser?.displayName;

    @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    super.dispose();
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
      appBar: AppBar(title: const Text('Edit Name'),backgroundColor: Colors.red,),
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
                  width: 330,
                  child:  Text(
                    "What's Your Name?",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: TextFormField(
                            // Handles Form Validation for First Name
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return 'Only Letters Please';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'First Name'),
                            controller: firstNameController,
                          ))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: TextFormField(
                            // Handles Form Validation for Last Name
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return 'Only Letters Please';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Last Name'),
                            controller: secondNameController,
                          )))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 330,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            String updatedUsername = firstNameController.text + " " + secondNameController.text;
                            // Validate returns true if the form is valid, or false otherwise.
                             if (_formKey.currentState!.validate() &&
                                RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text +
                                    secondNameController.text)) {
                              updateUserValue(updatedUsername);
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileDetailPage()));
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15,color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[200],
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                        ),
                      )))
            ],
          )
            ],
          ),
        )
    );
  }  

  Future<void> updateUserValue(String displayName) async {
    final FirebaseAuth user = FirebaseAuth.instance;
    User? currentUser = user.currentUser;

    currentUser?.updateDisplayName(displayName);
    final database = FirebaseDatabase.instance.ref();
    final userData = database.child('user/' + user.currentUser!.uid);
    userData
    .update({'email': user.currentUser!.email,'type': 'passenger', 'uid':user.currentUser!.uid, 'username': displayName});
    await currentUser?.reload();
    Navigator.pop(context,displayName);

}
}
