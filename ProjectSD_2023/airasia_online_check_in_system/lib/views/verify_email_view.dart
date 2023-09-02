import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        backgroundColor: Colors.red,
        ),
      body: Column(
        children: [
        const Text('Please verify your email address:'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            verifyEmail();
          }, 
          child: const Text('Send email verification'))
        ],
      ),
    );
  }

  Future verifyEmail() async {

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => Center(child:const CircularProgressIndicator()),
    );

      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('Please check your email inbox')),
      );
      Navigator.pop(context);
    Navigator.popUntil(context,(route) => route.isFirst); // Close the loading dialog

    Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginView())
                );
  }
}
