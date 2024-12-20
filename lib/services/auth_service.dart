import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:social_media_app/ui/login_screen.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Observable for the current user and authentication status
  var isAuthenticated = false.obs;
  var currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen for authentication state changes
    _auth.authStateChanges().listen((user) {
      currentUser.value = user;
      isAuthenticated.value = user != null;
      if (user != null) {
        _createOrUpdateUserProfile(user); // Ensure user profile exists or gets updated
      }
    });
  }

  // Google Sign-In method
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _createOrUpdateUserProfile(user);
      }

      currentUser.value = user;
      isAuthenticated.value = user != null;

      return user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();  // Ensure Google Sign-In is also signed out
      currentUser.value = null;
      isAuthenticated.value = false;

      // Navigate to the login screen after sign-out
      Get.offAll(() => LoginScreen());
    } catch (e) {
      print("Error signing out: $e");
      // Handle errors gracefully, e.g., show a Snackbar or an error message
      Get.snackbar("Error", "Failed to sign out. Please try again.");
    }
  }

  // Create or update user profile in Firestore
  Future<void> _createOrUpdateUserProfile(User user) async {
    try {
      final userRef = _db.collection('users').doc(user.uid);

      // Fetch the existing user document
      final userDoc = await userRef.get();

      // If user document does not exist, create it
      if (!userDoc.exists) {
        await userRef.set({
          'uid': user.uid,
          'displayName': user.displayName ?? 'Anonymous',
          'email': user.email ?? 'No Email',
          'photoURL': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing user document with new details if any
        await userRef.update({
          'displayName': user.displayName ?? 'Anonymous',
          'email': user.email ?? 'No Email',
          'photoURL': user.photoURL ?? '',
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error while creating/updating user profile: $e");
    }
  }
}
