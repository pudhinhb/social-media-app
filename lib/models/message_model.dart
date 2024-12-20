import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final String messageType;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.timestamp,
  });

  // Factory method to create a Message from Firestore document
  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      senderId: data['senderID'],
      receiverId: data['receiverID'],
      message: data['message'],
      messageType: data['messageType'],
      timestamp: data['timestamp'] as Timestamp,  // Cast correctly to Timestamp
    );
  }

  // Method to convert the Message object into a map that can be stored in Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderId,
      'receiverID': receiverId,
      'message': message,
      'messageType': messageType,
      'timestamp': timestamp,  // Don't modify this field
    };
  }
}
