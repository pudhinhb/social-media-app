import 'package:flutter/material.dart';
import 'package:social_media_app/models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: post.imageUrl != null
            ? Image.network(post.imageUrl!)  // Display image if available
            : Icon(Icons.image_not_supported),  // Fallback icon if no image
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.userName),  // Display user name
            SizedBox(height: 4),
            Text(post.content),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Likes: ${post.likeCount}'),
            Text('Comments: ${post.commentCount}'),
            Text('Shares: ${post.shareCount}'),
            Text('Timestamp: ${post.timestamp.toDate().toLocal()}'),
          ],
        ),
      ),
    );
  }
}
