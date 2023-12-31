// ignore_for_file: unused_import, unused_field, unnecessary_null_comparison, unused_local_variable, library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, unused_element, prefer_const_constructors

import 'package:airasia_online_check_in_system/main_page/about_us.dart';
import 'package:airasia_online_check_in_system/main_page/contact_us.dart';
import 'package:airasia_online_check_in_system/profile/profile_detail_view.dart';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  late User? user;
  final profilePictureKey = GlobalKey();
  String _userPhotoURL = FirebaseAuth.instance.currentUser?.photoURL ?? '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user!.photoURL);
  }

  void updatePhotoURL(String newURL) {
    if (newURL != null && user!.photoURL != null) {
      setState(() {
        print(newURL);
        _userPhotoURL = newURL;
        user!.updatePhotoURL(newURL);
      });
    }
  }

  Widget buildBackgroundImage() {
  return Container(
    width: 800,
    child: Image.asset(
      'assets/background-wallpaper.jpg', // Replace with your image asset path
      fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    String getUserProfilePictureUrl() {
      // Check if the user is signed in and has a photoURL
      if (user != null && user.photoURL != null) {
        return user.photoURL!; // Use the user's photoURL as is
      } else {
        // Return the default image URL or a placeholder URL for local assets
        return 'assets/default_user.png';
      }
    }
    final profilePictureKey = GlobalKey();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 222, 212, 185),
      body: Stack(
        children: <Widget>[
          buildBackgroundImage(),

          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                      title: 'About Us',
                      icon: Icons.info,
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AboutUsPage()));
                      }),
                  ProfileMenuWidget(
                    title: 'Contact Us',
                    icon: Icons.phone,
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ContactUsPage()));
                    },
                  ),
                  ProfileMenuWidget(
                      title: 'Log out',
                      icon: Icons.exit_to_app,
                      onPress: () async {
                        final shouldLogout = await showLogOutDialog(context);
                        if (shouldLogout) {
                          await FirebaseAuth.instance.signOut();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginView()));
                        }
                      }),
                ],
              ),),),],
      )
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.amberAccent.withOpacity(0.1),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),),);
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),],);},
  ).then((value) => value ?? false);
}
