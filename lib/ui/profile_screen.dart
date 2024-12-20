import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // For utf8 and md5 conversions
import 'package:social_media_app/controllers/feed_controller.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/services/auth_service.dart'; // Import AuthService for logout
import 'package:social_media_app/ui/login_screen.dart'; // Import LoginScreen for navigation after sign-out

class ProfileScreen extends StatelessWidget {
  final FeedController controller = Get.find<FeedController>();
  final User currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.green),
            onPressed: () async {
              final AuthService authService = Get.find<AuthService>();
              await authService.signOut(); // Log out the user
              Get.offAll(() => LoginScreen()); // Redirect to LoginScreen after sign-out
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          Divider(color: Colors.lightGreen[300]),
          Expanded(child: _buildUserPosts(context)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    // Check if user has photoURL, otherwise use Gravatar
    String profileImageUrl = currentUser.photoURL ?? _generateGravatarUrl(currentUser.email ?? '');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl)
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
            radius: 50.0, // Adjust size of avatar
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.displayName ?? 'No Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 4),
              Text(
                currentUser.email ?? 'No Email',
                style: TextStyle(fontSize: 16, color: Colors.lightGreen[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserPosts(BuildContext context) {
    final userPosts = controller.posts.where((post) => post.userId == currentUser.uid).toList();

    if (userPosts.isEmpty) {
      return Center(
        child: Text('You haven’t posted anything yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final Post post = userPosts[index];
        return _buildPostItem(context, post);
      },
    );
  }

  Widget _buildPostItem(BuildContext context, Post post) {
    return GestureDetector(
      onTap: () {
        // Show post details when tapped
        _showPostDetails(context, post);
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.1),
        color: Colors.lightGreen[50], // Light green background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Post Thumbnail (small image)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: post.imageUrl != null
                    ? Image.network(
                        post.imageUrl!,
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60.0,
                        height: 60.0,
                        color: Colors.grey,
                        child: Icon(Icons.image, color: Colors.white),
                      ),
              ),
              SizedBox(width: 16),
              // Post Content Snippet
              Expanded(
                child: Text(
                  post.content,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostDetails(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(post.content, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post.imageUrl != null)
              Image.network(post.imageUrl!),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 18, color: Colors.green),
                    SizedBox(width: 4),
                    Text(post.likeCount.toString(), style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment, size: 18, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(post.commentCount.toString(), style: TextStyle(color: Colors.green)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.share, size: 18, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(post.shareCount.toString(), style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  // Generate Gravatar URL from email
  String _generateGravatarUrl(String email) {
    final emailTrimmed = email.trim().toLowerCase();
    final emailHash = md5.convert(utf8.encode(emailTrimmed)).toString();
    return 'https://www.gravatar.com/avatar/$emailHash?s=200&d=identicon';
  }
}
