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

        // Wait for the upload to complete.
        await uploadTask.whenComplete(() async {
          // Get the download URL for the uploaded image.
          final downloadURL = await storageRef.getDownloadURL();

          // Update the user's profile with the new photo URL.
          await user?.updatePhotoURL(downloadURL);

          // Reload the user to get the updated information.
          await user?.reload();

          // Update the 'user' object with the reloaded user data.
          user = FirebaseAuth.instance.currentUser;

          setState(() {
            isUploading = false;
          });

  print('Updated URL: $downloadURL');
          // Navigate back to the previous screen.
          Navigator.pop(context,downloadURL);
        });
      } else {
        setState(() {
          isUploading = false;
        });
      }
    } catch (e) {
      // Handle errors
      print('Error uploading image: $e');
      setState(() {
        isUploading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Picture'),),
      body: SingleChildScrollView(
        child: Column(
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
                    child: isUploading
                        ? CircularProgressIndicator()
                        : const Text(
                            'Update',
                            style: TextStyle(fontSize: 15),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}