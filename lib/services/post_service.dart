import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a Post
  Future<void> createPost(String content, String? imageUrl) async {
    try {
      final user = _auth.currentUser; // Get the currently logged-in user
      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      final userId = user.uid; // Fetch the user's UID

      final postRef = _db.collection('posts').doc(); // Create a new post document
      await postRef.set({
        'userId': userId, // Use the authenticated user's UID
        'content': content,
        'imageUrl': imageUrl,
        'likeCount': 0,
        'commentCount': 0,
        'shareCount': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error creating post: $e");
      rethrow;
    }
  }
}
