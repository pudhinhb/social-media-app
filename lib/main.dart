import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:social_media_app/ui/login_screen.dart';
import 'package:social_media_app/ui/home_screen.dart';
import 'package:social_media_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(); // Initialize Firebase
    // Register AuthService with GetX
    Get.put(AuthService()); // Ensure AuthService is available globally
  } catch (e) {
    // Handle Firebase initialization error
    runApp(ErrorApp(message: 'Failed to initialize Firebase: $e'));
    return;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social Media App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthHandler(),
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    return Obx(() {
      // Check authentication state and show appropriate screen
      if (authService.isAuthenticated.value) {
        return HomeScreen(); // Navigate to HomeScreen if authenticated
      } else {
        return LoginScreen(); // Navigate to LoginScreen if not authenticated
      }
    });
  }
}

class ErrorApp extends StatelessWidget {
  final String message;

  const ErrorApp({required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      home: Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
