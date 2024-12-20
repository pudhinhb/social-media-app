import 'package:flutter/material.dart';
import 'package:social_media_app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:social_media_app/ui/home_screen.dart';
import 'package:sign_in_button/sign_in_button.dart';  // Import the sign_in_button package

class LoginScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media App',  // Custom title
          style: TextStyle(
            fontSize: 24,  // Font size for the title
            fontWeight: FontWeight.bold,  // Bold font
            fontFamily: 'Roboto',  // Custom font family
            letterSpacing: 1.2,  // Spacing between letters
          ),
        ),
        backgroundColor: Colors.green,  // Light green app bar
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Obx(() {
              // Listen for the current user status
              if (authService.isAuthenticated.value) {
                // If the user is authenticated, show the Logout button
                return ElevatedButton(
                  onPressed: () async {
                    await authService.signOut(); // Sign out using AuthService
                    Get.offAll(LoginScreen()); // Redirect to LoginScreen after logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Red color for the logout button
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                // If the user is not authenticated, show the Google Sign-In button using SignInButton
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login with',  // Text above the button
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),  // Space between text and button
                    SignInButton(
                      Buttons.google,  // Google button style
                      onPressed: () async {
                        await authService.signInWithGoogle();
                        Get.offAll(HomeScreen()); // Redirect to HomeScreen after login
                      },
                    ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
