import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/feed_controller.dart';
import 'package:social_media_app/models/post.dart';
import 'package:intl/intl.dart';  // Import the intl package
import 'package:cached_network_image/cached_network_image.dart';  // Image caching

class FeedScreen extends StatelessWidget {
  final FeedController feedController = Get.put(FeedController());

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        backgroundColor: Colors.lightGreen,  // Light green theme for the app bar
      ),
      body: Obx(() {
        if (feedController.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: feedController.posts.length,
          itemBuilder: (context, index) {
            Post post = feedController.posts[index];

            // Convert Timestamp to DateTime if it's not null
            String formattedTime = post.timestamp != null
                ? DateFormat('dd MMM hh:mm a').format(post.timestamp!.toDate()) // Convert Timestamp to DateTime
                : 'N/A';

            return _buildPostCard(context, post, formattedTime, screenWidth);
          },
        );
      }),
    );
  }

  // Post Card Builder
  Widget _buildPostCard(BuildContext context, Post post, String formattedTime, double screenWidth) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,  // White background for posts
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.photoURL.isNotEmpty
                      ? NetworkImage(post.photoURL)
                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                  radius: 30.0,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,  // Adjust font size based on screen width
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.blueAccent,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Post Content Section
            if (post.content.isNotEmpty)
              Text(
                post.content,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            const SizedBox(height: 12),
            
            // Image Section (With Caching)
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl!,
                    fit: BoxFit.cover,
                    width: screenWidth,  // Make the image responsive
                    height: 250,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Text('Image failed to load.', textAlign: TextAlign.center),
                  ),
                ),
              ),
            const SizedBox(height: 14),

            // Actions Section (Like, Comment, Share)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up, color: Colors.lightGreen),
                  onPressed: () => feedController.likePost(post.id),
                ),
                Text(post.likeCount.toString(), style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.green),
                  onPressed: () => feedController.commentPost(post.id),
                ),
                Text(post.commentCount.toString(), style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),

                IconButton(
                  icon: const Icon(Icons.share, color: Colors.orange),
                  onPressed: () => feedController.sharePost(post.id),
                ),
                Text(post.shareCount.toString(), style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            // Timestamp Section
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Posted on: $formattedTime', // Use the formatted timestamp
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
