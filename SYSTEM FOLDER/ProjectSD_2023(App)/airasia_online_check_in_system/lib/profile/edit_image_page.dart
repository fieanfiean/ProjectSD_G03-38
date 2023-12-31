// ignore_for_file: unused_import, depend_on_referenced_packages, use_build_context_synchronously, avoid_print, sized_box_for_whitespace, prefer_const_constructors

import 'dart:io';
import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({super.key});

  @override
  State<EditImagePage> createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imagePath;
  bool isUploading = false;

  Future<void> uploadImageToFirebase(BuildContext context) async {
    try {
      setState(() {
        isUploading = true;
      });

      if (imagePath != null && imagePath!.isNotEmpty) {
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref().child('profile_pictures/${user?.uid}');
        final uploadTask = storageRef.putFile(File(imagePath!));

        await uploadTask.whenComplete(() async {
          final downloadURL = await storageRef.getDownloadURL();
          await user?.updatePhotoURL(downloadURL);
          await user?.reload();
          user = FirebaseAuth.instance.currentUser;
          setState(() {
            isUploading = false;
          });
          Navigator.pop(context,downloadURL);
        });
      } else {
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
       print('Error uploading image: $e');
      setState(() {
        isUploading = false;
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Picture'),backgroundColor: Colors.red),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            buildBackgroundImage(),
            Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 330,
              child: const Text(
                "Upload a photo of yourself:",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 330,
                child: GestureDetector(
                  onTap: () async {
                    final image =
                        await ImagePicker().pickImage(source: ImageSource.gallery);

                    if (image == null) return;

                    final location = await getApplicationDocumentsDirectory();
                    final name = basename(image.path);
                    final imageFile = File('${location.path}/$name');
                    final newImage = await File(image.path).copy(imageFile.path);
                    setState(() {
                      imagePath = newImage.path;
                    });
                  },
                  child: user?.photoURL != null && imagePath == null
                      ? Image.network(user!.photoURL!)
                      : imagePath != null
                          ? Image.file(File(imagePath!))
                          : const Icon(Icons.add_a_photo),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isUploading ? null : () => uploadImageToFirebase(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[200],
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                    child: isUploading
                        ? CircularProgressIndicator()
                        : const Text(
                            'Update',
                            style: TextStyle(fontSize: 15,color: Colors.black),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
          ],
        )
      ),
    );
  }
}