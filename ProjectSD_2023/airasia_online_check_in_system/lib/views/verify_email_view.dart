import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
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

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        backgroundColor: Colors.red,
        ),
      body: Stack(
        children: [
          buildBackgroundImage(),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                const Text('Please verify your email address:'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                      verifyEmail();
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginView())
                      );
                              }, 
                              child: const Text('Send email verification',style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow[200],
                                    side: BorderSide.none,
                                    shape: const StadiumBorder(),
                                  ),),
                )
                    ],
                  ),
            ),
          ),
        ],
      )
    );
  }

  Future verifyEmail() async {

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => Center(child:const CircularProgressIndicator()),
    );

      // Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('Please check your email inbox')),
      );
      //Navigator.pop(context);
    Navigator.popUntil(context,(route) => route.isFirst); // Close the loading dialog

    
  }
}
