// ignore: unused_import
// ignore_for_file: avoid_print, unused_import, duplicate_ignore, sized_box_for_whitespace, prefer_const_constructors, sort_child_properties_last

import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

Future<void> changePassword(String currentPassword, String newPassword) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    AuthCredential credential = EmailAuthProvider.credential(
      email: user?.email ?? '',
      password: currentPassword,
    );
    await user?.reauthenticateWithCredential(credential);
    await user?.updatePassword(newPassword);
    print('Password changed successfully');
  } catch (e) {
    print('Error changing password: $e');
  }
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
      appBar: AppBar(
        title: const Text('Change password'),
        backgroundColor: Colors.red,
      ),
      body: Form(
          key: _formKey,
          child: Stack(
            children: [
              buildBackgroundImage(),
              Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 320,
                    child: const Text(
                      "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          controller: oldPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Old Password',
                          ),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Your New Password',
                          ),
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,            
                          decoration: const InputDecoration(
                            labelText: 'Confirm Your New Password',
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
                                if (passwordController.text == confirmPasswordController.text) {
                                  if (passwordController.text != oldPasswordController.text) {
                                    changePassword(oldPasswordController.text, confirmPasswordController.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Password Successfully Changed')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('New password should be different from the old password')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Passwords do not match')),
                                  );
                                }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15,color: Colors.black)
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
   