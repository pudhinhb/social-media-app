import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types; // Corrected import
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

class ChatScreen extends StatelessWidget {
  final types.Room room; // The room object for the chat

  ChatScreen({required this.room, required String receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name ?? 'Chat'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<types.Message>>(
              stream: FirebaseChatCore.instance.messages(room), // Fetch chat messages
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return Chat(
                  messages: messages,
                  onSendPressed: (partialMessage) async {
                    if (partialMessage is types.PartialText) {
                      // Send message
                      FirebaseChatCore.instance.sendMessage(
                        types.PartialText(text: partialMessage.text),
                        room.id, // Room ID
                      );
                    }
                  },
                  user: types.User(
                    id: FirebaseAuth.instance.currentUser!.uid, // Current user ID
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
