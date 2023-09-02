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
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here'
            ),
          ),
          ElevatedButton.icon(
            onPressed: resetPassword, 
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.email_outlined),
            label: const Text('Reset password'),
          ),
        ]
      ),
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