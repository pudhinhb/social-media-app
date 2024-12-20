import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/post.dart';

class FeedController extends GetxController {
  var posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // Load posts and attach user data
  void loadPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      var loadedPosts = <Post>[];

      for (var doc in snapshot.docs) {
        final userId = doc['userId'];

        // Fetch the user's details from the 'users' collection
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          final userName = userDoc['displayName'] ?? 'Unknown';
          final photoUrl = userDoc['photoURL'] ?? '';

          // Create a Post object with the user details
          final post = Post(
            id: doc.id,
            userId: userId,
            userName: userName,
            photoURL: photoUrl,
            content: doc['content'] ?? '',
            imageUrl: doc['imageUrl'],
            likeCount: doc['likeCount'] ?? 0,
            shareCount: doc['shareCount'] ?? 0,
            commentCount: doc['commentCount'] as int? ?? 0,
            timestamp: doc['timestamp'] as Timestamp? ?? Timestamp.now(),
          );
          loadedPosts.add(post);
        }
      }

      posts.assignAll(loadedPosts);
    });
  }

  // Increment like count
  void likePost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'likeCount': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error liking post: $e");
    }
  }

  // Increment share count
  void commentPost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'commentCount': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error sharing post: $e");
    }
  }
   void sharePost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'shareCount': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error sharing post: $e");
    }
  }
}
