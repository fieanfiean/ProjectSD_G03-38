// ignore_for_file: use_build_context_synchronously

import 'package:airasia_online_check_in_system/main.dart';
import 'package:airasia_online_check_in_system/views/forgot_password_view.dart';
import 'package:airasia_online_check_in_system/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email; 
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // TextField(
          //   controller: _email,
            // enableSuggestions: false,
            // autocorrect: false,
            // keyboardType: TextInputType.emailAddress,
          //   decoration: const InputDecoration(
          //     hintText: 'Enter your email here'
          //   ),
          // ),
         
          // TextField(
          //   controller: _password,
          //   obscureText: true,
          //   enableSuggestions: false,
          //   autocorrect: false,
          //   decoration: const InputDecoration(
          //     hintText: 'Enter your password here',  
          //   ),
          // ),
           Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Your email address'),
                          controller: _email,
                        ))),
           Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              labelText: 'Your Password'),
                          controller: _password,
                        ))),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    try{
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: email, 
                      password: password
                    );
                    print(userCredential);
                  } on FirebaseAuthException catch (e) {
                    if(e.code == 'user-not-found'){
                      print('User not found');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Login Failed'),
                            content: const Text('The email you entered is incorrect. Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }else if(e.code == 'wrong-password'){
                      print('Wrong password');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Login Failed'),
                            content: const Text('The password you entered is incorrect. Please try again.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomePage())
                      );

                  },
                  child: 
                        const Text(
                          'Login',
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ),
          ),
          
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassowrdView())
                      );
            }, 
            child: const Text('Forgot password'),
          ),

          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 330,
                height: 50,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterView())
                    );
                  },
                  child: 
                        const Text(
                          'Register',
                          style: TextStyle(fontSize: 15),
                        ),
                ),
              ),
            ),
          ),
          
          
        ],
      ),
    );
  }
}