import 'package:airasia_online_check_in_system/views/login_view.dart';
import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add this FutureBuilder to handle navigation after a delay
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)), // Delay for 3 seconds
      builder: (context, snapshot) {
      switch(snapshot.connectionState){
      case ConnectionState.done:    // After the delay, navigate to another page (e.g., LoginView)
          return LoginView();
      default:  // While waiting, you can display your splash screen
        return Scaffold(
          body: Stack(
            fit: StackFit.expand, // Make the stack's children fill the screen
            children: [
              Image.asset(
                'assets/background-wallpaper.jpg', // Replace with your image path
                fit: BoxFit.cover, // Adjust the BoxFit property to control how the image is scaled
              ),
              const Center(
                child: Text(
                  'Welcome to AirAsia Online Check-in System',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set text color
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
      },
    );
  }
}
