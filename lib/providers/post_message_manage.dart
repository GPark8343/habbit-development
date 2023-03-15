import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:habbit/models/folder.dart';
import 'package:uuid/uuid.dart';

class PostMessageManage extends ChangeNotifier {
  sendMessage(String messageText, String postId) async {
    var uid = Uuid().v1();
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(postId)
        .collection(postId)
        .doc(uid)
        .set({
      'postId': postId,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'text': messageText,
      'created_at': DateTime.now(),
      'uid': uid
    });
  }
}
