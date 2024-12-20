import 'package:flutter/material.dart';
import 'package:social_media_app/services/post_service.dart';

class PostScreen extends StatelessWidget {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post content TextField
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: "Post Content",
                labelStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              maxLines: 3,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            // Image URL TextField
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: "Image URL (optional)",
                labelStyle: TextStyle(color: Colors.green),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 32), // Space before button
            // Center the Create Post Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final content = contentController.text.trim();
                  final imageUrl = imageUrlController.text.trim().isNotEmpty
                      ? imageUrlController.text.trim()
                      : null;

                  if (content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Post content cannot be empty!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    await postService.createPost(content, imageUrl);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Post created successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    contentController.clear();
                    imageUrlController.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to create post: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, 
                  backgroundColor: Colors.white, // White text
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text("Create Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
