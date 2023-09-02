import 'package:airasia_online_check_in_system/main.dart';
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
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here'
            ),
          ),
      
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',  
            ),
          ),
      
          TextButton(
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
              }else if(e.code == 'wrong-password'){
                print('Wrong password');
              }
            }
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage())
                );

            },
            child: const Text('Login'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterView())
                );
            } ,
            child: const Text('Not registered yet? Register here!'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/forgotPassword/', 
                (route) => false,
                );
            }, 
            child: const Text('Forgot password'),
          )
        ],
      ),
    );
  }
}