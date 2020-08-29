import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> insertUser({
    String id,
    String email,
    String name,
  }) {
    return users.doc(id).set({
      'id': id,
      'name': name,
      'email': email,
      'chattingWith': null,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> updateChattingWith({
    String docId,
    String rivalId,
  }) {
    return users.doc(docId).update({
      'chattingWith': rivalId,
    });
  }

  Future<void> chatting({
    String chatId,
    String fromId,
    String toId,
    String content,
  }) {
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
          messages
              .doc(chatId)
              .collection(chatId)
              .doc(DateTime.now().millisecondsSinceEpoch.toString()),
          {
            'formId': fromId,
            'toId': toId,
            'content': content,
            'createdAt': DateTime.now(),
          });
    });
  }
}
