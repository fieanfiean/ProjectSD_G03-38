import 'package:airasia_online_check_in_system/firebase_options.dart';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:airasia_online_check_in_system/views/register_view.dart';
import 'package:airasia_online_check_in_system/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                return const NotesView();
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

enum MenuAction { logout }


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/', 
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder:(context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value:MenuAction.logout, 
                  child:Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            }, 
            child:  const Text('Cancel')),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(true);
            }, 
            child:  const Text('Log out'),
          ),
        ],
      ); 
    },
  ).then((value) => value ?? false);
}
