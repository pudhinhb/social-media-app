import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/ui/chat/chat_screen.dart'; // Import ChatScreen
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a User to Chat'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          var users = snapshot.data!.docs;

          final currentUser = _auth.currentUser;
          users = users.where((user) => user['email'] != currentUser?.email).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              String displayName = user['displayName'] ?? 'Unknown User';
              String email = user['email'] ?? 'No Email';
              String userId = user.id;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(displayName.isNotEmpty ? displayName[0].toUpperCase() : '?'),
                ),
                title: Text(displayName),
                subtitle: Text(email),
                onTap: () async {
                  // Fetch or create the chat room
                  var room = await _getChatRoom(currentUser?.uid ?? '', userId);
                  // Navigate to ChatScreen with the room
                  Get.to(() => ChatScreen(room: room, receiverId: userId));
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<types.Room> _getChatRoom(String currentUserId, String receiverId) async {
    var roomsCollection = FirebaseFirestore.instance.collection('chat_rooms');
    var roomSnapshot = await roomsCollection
        .where('users', arrayContains: currentUserId)
        .where('users', arrayContains: receiverId)
        .get();

    if (roomSnapshot.docs.isEmpty) {
      var newRoomRef = await roomsCollection.add({
        'users': [currentUserId, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      return types.Room(id: newRoomRef.id, name: 'Chat with $receiverId', users: [], type: null);
    } else {
      var existingRoom = roomSnapshot.docs.first;
      return types.Room(id: existingRoom.id, name: 'Chat with $receiverId', type: null, users: []);
    }
  }
}
