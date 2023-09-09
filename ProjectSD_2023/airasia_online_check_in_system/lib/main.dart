// ignore_for_file: unused_import

import 'package:airasia_online_check_in_system/firebase_options.dart';
import 'package:airasia_online_check_in_system/profile/edit_email_page.dart';
import 'package:airasia_online_check_in_system/profile/edit_image_page.dart';
import 'package:airasia_online_check_in_system/profile/edit_name_page.dart';
import 'package:airasia_online_check_in_system/views/forgot_password_view.dart';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:airasia_online_check_in_system/views/main_page_view.dart';
import 'package:airasia_online_check_in_system/views/register_view.dart';
import 'package:airasia_online_check_in_system/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

void main() async{
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
        '/forgotPassword/':(context) => const ForgotPassowrdView(),
        '/editImage': (context) => const EditImagePage(),
        '/editName': (context) => const EditNamePage(),
        '/editEmail': (context) => const EditEmailPage(),
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
                return const MainPageView();
              } else {
                return const VerifyEmailView();
              }
            }
          default:
            return const CircularProgressIndicator();
        }   
      },
    );
  }

  
}




