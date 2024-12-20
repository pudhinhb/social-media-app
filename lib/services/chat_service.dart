import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get messages for the chat screen
  Stream<List<Message>> getMessages(String receiverId) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      return _firestore
          .collection('chats')
          .doc(currentUser.uid)
          .collection(receiverId)
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Message.fromFirestore(doc.data())).toList();
      });
    } else {
      throw Exception("No authenticated user found.");
    }
  }

  // Send a new message
  Future<void> sendMessage(String receiverId, Message message) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        // Save the message in the sender's collection
        await _firestore.collection('chats')
            .doc(currentUser.uid)
            .collection(receiverId)
            .add(message.toMap());

        // Save the message in the receiver's collection as well
        await _firestore.collection('chats')
            .doc(receiverId)
            .collection(currentUser.uid)
            .add(message.toMap());
      } catch (e) {
        throw Exception("Error sending message: $e");
      }
    } else {
      throw Exception("No authenticated user found.");
    }
  }
}
