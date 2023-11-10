// ignore_for_file: unused_local_variable, sized_box_for_whitespace, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, sort_child_properties_last

import 'package:airasia_online_check_in_system/main.dart';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  late final TextEditingController _email;
  late final TextEditingController _password;
  String errorMessage = ''; // To store error message


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
        title: const Text('Register'),
        backgroundColor: Colors.red,
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
      
          Text(errorMessage, style: TextStyle(color: Colors.red)), // Error message text

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
                        .createUserWithEmailAndPassword(
                      email: email, 
                      password: password
                    ); 
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Register Successful'),
                          content: Text("Please login."),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    // final user = User(email: email);
                    // createUser(user);
                    final user = FirebaseAuth.instance.currentUser?.uid;
                    final database = FirebaseDatabase.instance.ref();
                    final userData = database.child('user/' + user!);
                    userData
                    .set({'email': email,'type': 'passenger', 'uid':user, 'username':""});
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomePage()));


                    //print(userCredential);
                    } on FirebaseAuthException catch(e) {
                      if(e.code == 'weak-password'){
                        print('Weak password');
                        setState(() {
                          errorMessage = 'Password should be at least 6 character.';
                        });                 
                      } else if(e.code == 'email-already-in-use'){
                        print('Email is already in use');
                          setState(() {
                          errorMessage = 'Email is already in use';
                        });
                      } else if(e.code == 'invalid-email'){
                        print('Invalid email');
                        setState(() {
                          errorMessage = 'Invalid email';
                        });
                      }
                    }
                  },
                  child: 
                        const Text(
                          'Register',
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
          
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginView()));
          }, 
          child: const Text('Already registered? Login here!',style: TextStyle(color: Colors.black),))
        ],
      ),
        ],
      )
    );
  }



  Future createUser(User user) async {
      // final docUser = FirebaseFirestore.instance.collection('User').doc();
      // user.id = docUser.id;
      // final json = user.toJson();
      // await docUser.set(json);

      
    }
}

class User {
  String id;
  final String name;
  final String email;
  final String phone;
  final String type;

  User({
    this.id = '',
    this.name = '',
    this.phone = '',
    this.type = 'user',
    required this.email
  });

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'name' : name,
    'email' : email,
    'phone' : phone,
    'type' : type,
  };
}

