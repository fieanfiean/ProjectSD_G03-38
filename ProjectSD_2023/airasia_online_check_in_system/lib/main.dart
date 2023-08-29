import 'package:airasia_online_check_in_system/firebase_options.dart';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:airasia_online_check_in_system/views/register_view.dart';
import 'package:airasia_online_check_in_system/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const RegisterView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if(user == null){
              return const LoginView();

            } else {
              if (user.emailVerified){
                print('Email is verified');
              } else {
                return const VerifyEmailView();
              }
            }
            return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }   
      },
    );
  }
}



