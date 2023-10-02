import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassowrdView extends StatefulWidget {
  const ForgotPassowrdView({super.key});

  @override
  State<ForgotPassowrdView> createState() => _ForgotPassowrdViewState();
}

class _ForgotPassowrdViewState extends State<ForgotPassowrdView> {

  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }


  Widget buildBackgroundImage() {
    return Container(
      width: 800,
      height: 800,
      child: Image.asset(
        'assets/background-wallpaper-2.jpg', // Replace with your image asset path
        fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Forgot password'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginView())
                );
          },
        )
      ),
      body: Stack(
        children: [
          buildBackgroundImage(),
          Column(
        children: [
          // TextField(
          //   controller: _email,
          //   enableSuggestions: false,
          //   autocorrect: false,
          //   keyboardType: TextInputType.emailAddress,
          //   decoration: const InputDecoration(
          //     hintText: 'Enter your email here'
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
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: resetPassword,
                    child: 
                          const Text(
                            'Reset password',
                            style: TextStyle(fontSize: 15,color: Colors.black),
                          ),
                    style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[200],
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                  ),
                ),
              ),
            ),

          // ElevatedButton.icon(
          //   onPressed: resetPassword, 
          //   style: ElevatedButton.styleFrom(
          //     minimumSize: Size.fromHeight(50),
          //   ),
          //   icon: Icon(Icons.email_outlined),
          //   label: const Text('Reset password'),
          // ),
        ]
      ),
        ],
      )
    );
  }

  Future resetPassword() async {
    final email = _email.text;

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => Center(child:const CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('Password Reset Email Sent')),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Navigator.popUntil(context,(route) => route.isFirst); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginView())
                );
  }
}