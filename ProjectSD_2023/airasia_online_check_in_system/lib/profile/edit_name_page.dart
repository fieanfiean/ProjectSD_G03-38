import 'package:firebase_auth/firebase_auth.dart';
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

//   void showSnackbar(BuildContext context, String message) {
//   if (mounted) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }

    @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    super.dispose();
  }

  // void updateUserValue(String displayName) async {
  //     final User? currentUser = FirebaseAuth.instance.currentUser;

  //     if (currentUser != null) {
  //       // Update the user's data as needed, e.g., update the displayName on Firebase
  //       // For example:
  //       // await currentUser.updateDisplayName(displayName);

  //       // Fetch the updated user information from Firebase
  //       final updatedUser = FirebaseAuth.instance.currentUser;

  //       // Call the callback to update the user data in ProfileDetailPage
  //       if (updatedUser != null) {
  //         widget.onUpdateName(displayName);
  //       }

  //       // Close the EditNamePage
  //       Navigator.pop(context);
  //     } 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Name')),
      body: Form(
          key: _formKey,
          child: Column(
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
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                             if (_formKey.currentState!.validate() &&
                                RegExp(r'^[a-zA-Z]+$').hasMatch(firstNameController.text +
                                    secondNameController.text)) {
                              updateUserValue(firstNameController.text +
                                  " " +
                                  secondNameController.text);
                              Navigator.pop(context);
                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileDetailPage()));
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      )))
            ],
          ),
        )
    );
  }  

  Future<void> updateUserValue(String displayName) async {
    final FirebaseAuth user = FirebaseAuth.instance;
    User? currentUser = user.currentUser;

    currentUser?.updateDisplayName(displayName);
    await currentUser?.reload();
}



}
