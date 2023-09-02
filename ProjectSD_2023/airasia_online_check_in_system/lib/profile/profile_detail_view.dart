// ignore_for_file: unused_import

import 'dart:async';
import 'dart:ffi';
import 'package:airasia_online_check_in_system/profile/edit_email_page.dart';
import 'package:airasia_online_check_in_system/profile/edit_image_page.dart';
import 'package:airasia_online_check_in_system/profile/edit_name_page.dart';
import 'package:airasia_online_check_in_system/profile/edit_phone_number_page.dart';
import 'package:airasia_online_check_in_system/profile/change_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> refreshPage() async{
    await user?.reload();
  }

  final profilePictureKey = GlobalKey();
    String _userPhotoURL = FirebaseAuth.instance.currentUser?.photoURL ?? '';

  
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
        print(user!.photoURL);
  }

  // void updatePhotoURL(String newURL) {
  //   // Trigger a rebuild of the profile picture widget
  //   setState(() {
  //     print(newURL);
  //     _userPhotoURL = newURL;
  //     user!.updatePhotoURL(newURL);

  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
              backgroundColor: Colors.red,
              elevation: 0,
              title: const Text('Edit Profile'),
              centerTitle: true,
            ),
      body: 
        RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    navigateEditPage(const EditImagePage());
                  },
                  child: DisplayImage(
                      imagePath: user?.photoURL??'',
                      onPressed: () {},
                      )
                ),
                buildUserInfoDisplay(user?.displayName ?? '', 'Name', const EditNamePage()),
                //buildUserInfoDisplay(user?.phoneNumber ?? '', 'Phone', const EditPhoneNumberPage()),
                buildUserInfoDisplay(user?.email ?? '', 'Email', const EditEmailPage()),
        Padding(
            padding: EdgeInsets.only(top: 150),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 320,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const ChangePasswordPage()));
                    },
                    child: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                )))
              ],
            )
          ),
        )
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        const SizedBox(height: 1,),
        Container(
            width: 350,
            height: 40,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                color: Colors.grey,
                width: 1,
                )
              )
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        navigateEditPage(editPage);
                      },
                    child: Text(
                      getValue,
                      style: TextStyle(fontSize: 16, height: 1.4),
                    )
                  )
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]
            )
          )
        ],        
      )
    );

  // Handles navigation and prompts refresh.
  void navigateEditPage(Widget editForm) async {
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => editForm));
    final updatedURL = await Navigator.of(context).push<String>(MaterialPageRoute(builder: (context) => editForm));
  if (updatedURL != null) {
    print('Received updated URL: $updatedURL');


    // Update the user's photo URL
    setState(() {
      _userPhotoURL = updatedURL;
    });
  }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}


class DisplayImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  // Constructor
  const DisplayImage({
    Key? key,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Color.fromRGBO(64, 105, 225, 1);

    return Center(
        child: Stack(children: [
      buildImage(color),
      Positioned(
        right: 4,
        top: 10,
        child: buildEditIcon(color),
      )
    ]));
  }

  // Builds Profile Image
  Widget buildImage(Color color) {
    // ignore: unnecessary_null_comparison
    if (imagePath != null && imagePath.isNotEmpty && imagePath.startsWith('https://')) {
      // Load the image from a network URL
      return CircleAvatar(
        radius: 75,
        backgroundColor: color,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imagePath),
          radius: 70,
        ),
      );
    } else {
      // Use the default user image from assets
      return CircleAvatar(
        radius: 75,
        backgroundColor: color,
        child: const CircleAvatar(
          backgroundImage: AssetImage('assets/default_user.png'),
          radius: 70,
        ),
      );
    }
  }

  // Builds Edit Icon on Profile Picture
  Widget buildEditIcon(Color color) => buildCircle(
      all: 8,
      child: Icon(
        Icons.edit,
        color: color,
        size: 20,
      ));

  // Builds/Makes Circle for Edit Icon on Profile Picture
  Widget buildCircle({
    required Widget child,
    required double all,
  }) =>
      ClipOval(
          child: Container(
        padding: EdgeInsets.all(all),
        color: Colors.white,
        child: child,
      ));
}