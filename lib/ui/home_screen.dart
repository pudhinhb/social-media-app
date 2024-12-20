import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/controllers/feed_controller.dart';
import 'package:social_media_app/ui/feed_screen.dart';
import 'package:social_media_app/ui/post_screen.dart';
import 'package:social_media_app/ui/profile_screen.dart';
import 'package:social_media_app/ui/chat/user_list_screen.dart'; // User List Screen for chat

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final FeedController controller = Get.put(FeedController());

  final List<Widget> _screens = [
    FeedScreen(),
    Container(), // Placeholder for PostScreen, handled dynamically
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      _showPostDialog(); // Navigate to PostScreen when Plus (+) is tapped
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showPostDialog() async {
    await Get.to(PostScreen()); // Navigate to PostScreen for creating a new post
    setState(() {
      _selectedIndex = 0; // Return to Feed after posting
    });
  }

  void _openChatUserList() {
    Get.to(() => UserListScreen()); // Navigate to the User List screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat_bubble_outline),
            onPressed: _openChatUserList, // Open chat user list on tap
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightGreen,  // Change color of selected item to light green
        unselectedItemColor: Colors.grey,     // Set color for unselected items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
