// ignore: unused_import
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
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Create a credential using the user's email and current password
    AuthCredential credential = EmailAuthProvider.credential(
      email: user?.email ?? '',
      password: currentPassword,
    );

    // Reauthenticate the user with the current credential
    await user?.reauthenticateWithCredential(credential);

    // Now, you can change the password
    await user?.updatePassword(newPassword);
    print('Password changed successfully');
  } catch (e) {
    // Handle any errors that occur during reauthentication or password change
    print('Error changing password: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
      ),
      body: Form(
          key: _formKey,
          child: Column(
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
                                if(passwordController.text == confirmPasswordController.text){
                                  changePassword(oldPasswordController.text,confirmPasswordController.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content:Text('Password Sucessfully Change')),
                                  );
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
   