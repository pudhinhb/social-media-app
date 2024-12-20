import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;  // Added userName field
  final String photoURL;  // Added userAvatarUrl field
  final String content;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.userName,  // User name required
    required this.photoURL,  // User avatar URL required
    required this.content,
    this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.timestamp,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    // Fetch userName and userAvatarUrl from the document
    return Post(
      id: doc.id,
      userId: doc['userId'] as String? ?? '',
      userName: doc['userName'] as String? ?? 'Unknown',  // Fetch userName from Firestore
      photoURL: doc['photoURL'] as String? ?? '',  // Fetch userAvatarUrl from Firestore
      content: doc['content'] as String? ?? '',
      imageUrl: doc['imageUrl'] as String?,
      likeCount: doc['likeCount'] as int? ?? 0,
      commentCount: doc['commentCount'] as int? ?? 0,
      shareCount: doc['shareCount'] as int? ?? 0,
      timestamp: doc['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }
}
